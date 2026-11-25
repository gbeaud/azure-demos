#Requires -Version 5.1
#Requires -Modules Az.Accounts, Az.Network, Az.Resources, Az.Storage

<#
.SYNOPSIS
    Backs up an Azure Firewall and its firewall policy as an ARM template in Azure Blob Storage.

.DESCRIPTION
    Exports an Azure Firewall and its firewall policy as a single ARM template, without
    parameterization, and uploads the template to a blob container of a storage account. Each backup
    is stored in a new blob named after the firewall and the time of the backup, such as
    'fw-prod-westeu202611251430.json'.

    The script runs in the current Azure PowerShell context: before running it, sign in with
    Connect-AzAccount and select the subscription of the firewall with Set-AzContext. By default, the
    script authenticates to the storage account with the signed-in Microsoft Entra identity; use the
    StorageAccountKey parameter to authenticate with an access key instead.

    To back up the firewalls of several resource groups or subscriptions on a schedule, use
    Backup-AzFirewallToTemplateSpec.ps1 instead.

.PARAMETER ResourceGroupName
    The name of the resource group that contains the Azure Firewall and its firewall policy.

.PARAMETER FirewallName
    The name of the Azure Firewall to back up.

.PARAMETER FirewallPolicyName
    The name of the firewall policy to back up. The policy must be in the same resource group as the
    firewall.

.PARAMETER StorageAccountName
    The name of the storage account that stores the backups.

.PARAMETER ContainerName
    The name of the blob container that stores the backups. The container must already exist. The
    default value is 'firewall-backup'.

.PARAMETER StorageAccountKey
    An access key of the storage account. When omitted, the script authenticates to the storage
    account with the signed-in Microsoft Entra identity.

.EXAMPLE
    PS> $backup = @{
            ResourceGroupName  = 'rg-hub-connectivity-prod-westeu'
            FirewallName       = 'fw-prod-westeu'
            FirewallPolicyName = 'fp-firewall-policy-hub-prod-westeu-01'
            StorageAccountName = 'saresourcesbackup'
        }
    PS> .\Backup-AzFirewallToStorage.ps1 @backup -Verbose

    Backs up the firewall 'fw-prod-westeu' and its policy to the 'firewall-backup' container of the
    'saresourcesbackup' storage account, with the signed-in Microsoft Entra identity.

.EXAMPLE
    PS> $key = Read-Host -Prompt 'Access key of the storage account' -AsSecureString
    PS> .\Backup-AzFirewallToStorage.ps1 @backup -ContainerName 'fw-backup' -StorageAccountKey $key

    Backs up the firewall of the previous example to the 'fw-backup' container, and authenticates to
    the storage account with an access key.

.EXAMPLE
    PS> .\Backup-AzFirewallToStorage.ps1 @backup -WhatIf

    Shows the backup that the previous example would perform, without exporting or uploading
    anything.

.INPUTS
    None. You cannot pipe objects to this script.

.OUTPUTS
    AzureBackup.FirewallStorageBackupResult
        An object that describes the backup, with the SubscriptionId, ResourceGroupName,
        FirewallName, FirewallPolicyName, StorageAccountName, ContainerName, BlobName and BlobUri
        properties.

.NOTES
    Author       : Guillaume Beaud (Microsoft Cloud Solution Architect)
    Version      : 2.0.0
    Last updated : November 2026

    Requirements
      - The Az.Accounts, Az.Network, Az.Resources and Az.Storage PowerShell modules.
      - On the resource group of the firewall: the Contributor role, or a custom role that grants read
        access to the resources and the
        Microsoft.Resources/subscriptions/resourceGroups/exportTemplate/action permission.
      - On the storage account or the blob container: the Storage Blob Data Contributor role, unless
        the StorageAccountKey parameter is used.

    Naming
      The blob name is the name of the firewall followed by the time of the backup (yyyyMMddHHmm, in
      the local time of the host) and by the .json extension.

    Restore
      Download the template from the storage account, then deploy it to the resource group of the
      firewall:

        $storageContext = New-AzStorageContext -StorageAccountName 'saresourcesbackup' -UseConnectedAccount
        $download = @{
            Context     = $storageContext
            Container   = 'firewall-backup'
            Blob        = 'fw-prod-westeu202611251430.json'
            Destination = '.\fw-prod-westeu202611251430.json'
        }
        $null = Get-AzStorageBlobContent @download
        New-AzResourceGroupDeployment -ResourceGroupName 'rg-hub-connectivity-prod-westeu' -TemplateFile $download.Destination

      The deployment may fail with the error "Put on Firewall Policy <policy name> Failed with
      1 faulted referenced firewalls", because of the dependencies between the firewall and its
      policy. The resources are usually deployed correctly anyway; if not, associate the policy with
      the firewall again.

.LINK
    https://learn.microsoft.com/azure/firewall/overview

.LINK
    https://learn.microsoft.com/powershell/module/az.resources/export-azresourcegroup

.LINK
    https://learn.microsoft.com/azure/storage/blobs/authorize-data-operations-powershell
#>

[CmdletBinding(SupportsShouldProcess)]
[OutputType('AzureBackup.FirewallStorageBackupResult')]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FirewallName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FirewallPolicyName,

    [Parameter(Mandatory)]
    [ValidatePattern('^[a-z0-9]{3,24}$', Options = 'None')]
    [string]$StorageAccountName,

    [Parameter()]
    [ValidatePattern('^(?=.{3,63}$)[a-z0-9]+(-[a-z0-9]+)*$', Options = 'None')]
    [string]$ContainerName = 'firewall-backup',

    [Parameter()]
    [securestring]$StorageAccountKey
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$templateFilePath = $null

try {
    $context = Get-AzContext
    if ($null -eq $context -or $null -eq $context.Account -or $null -eq $context.Subscription) {
        throw 'No Azure context is available. Sign in with Connect-AzAccount and select the subscription of the firewall with Set-AzContext.'
    }
    Write-Verbose -Message "Using the Azure context of '$($context.Account.Id)' in subscription '$($context.Subscription.Name)' ($($context.Subscription.Id))."

    Write-Verbose -Message "Retrieving Azure Firewall '$FirewallName' and firewall policy '$FirewallPolicyName' in resource group '$ResourceGroupName'..."
    $firewall = Get-AzFirewall -Name $FirewallName -ResourceGroupName $ResourceGroupName
    $firewallPolicy = Get-AzFirewallPolicy -Name $FirewallPolicyName -ResourceGroupName $ResourceGroupName

    if ($null -eq $firewall.FirewallPolicy -or $firewall.FirewallPolicy.Id -ne $firewallPolicy.Id) {
        Write-Warning -Message "Firewall policy '$FirewallPolicyName' is not associated with Azure Firewall '$FirewallName'. Check the FirewallPolicyName parameter."
    }

    $timestamp = [datetime]::Now.ToString('yyyyMMddHHmm', [cultureinfo]::InvariantCulture)
    $blobName = '{0}{1}.json' -f $FirewallName, $timestamp
    $target = "Azure Firewall '$FirewallName' and firewall policy '$FirewallPolicyName'"
    $operation = "Back up to blob '$blobName' in container '$ContainerName' of storage account '$StorageAccountName'"

    if ($PSCmdlet.ShouldProcess($target, $operation)) {
        $templateFilePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $blobName

        Write-Verbose -Message 'Exporting the firewall and its policy as an ARM template...'
        $exportParameters = @{
            ResourceGroupName       = $ResourceGroupName
            Resource                = $firewall.Id, $firewallPolicy.Id
            Path                    = $templateFilePath
            SkipAllParameterization = $true
            Force                   = $true
            Confirm                 = $false
        }
        $null = Export-AzResourceGroup @exportParameters

        if ($PSBoundParameters.ContainsKey('StorageAccountKey')) {
            $plainTextKey = [System.Net.NetworkCredential]::new('', $StorageAccountKey).Password
            $storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $plainTextKey
        }
        else {
            $storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount
        }

        Write-Verbose -Message "Uploading the template to blob '$blobName' in container '$ContainerName' of storage account '$StorageAccountName'..."
        $uploadParameters = @{
            File      = $templateFilePath
            Container = $ContainerName
            Blob      = $blobName
            Context   = $storageContext
            Force     = $true
            Confirm   = $false
        }
        $null = Set-AzStorageBlobContent @uploadParameters

        $blobUri = '{0}/{1}/{2}' -f $storageContext.BlobEndPoint.TrimEnd('/'), $ContainerName, $blobName
        Write-Verbose -Message "Backup completed: $blobUri"

        [pscustomobject]@{
            PSTypeName         = 'AzureBackup.FirewallStorageBackupResult'
            SubscriptionId     = $context.Subscription.Id
            ResourceGroupName  = $ResourceGroupName
            FirewallName       = $FirewallName
            FirewallPolicyName = $FirewallPolicyName
            StorageAccountName = $StorageAccountName
            ContainerName      = $ContainerName
            BlobName           = $blobName
            BlobUri            = $blobUri
        }
    }
}
catch {
    $PSCmdlet.ThrowTerminatingError($_)
}
finally {
    if ($null -ne $templateFilePath -and (Test-Path -LiteralPath $templateFilePath)) {
        Remove-Item -LiteralPath $templateFilePath -Force -Confirm:$false -ErrorAction SilentlyContinue
    }
}
