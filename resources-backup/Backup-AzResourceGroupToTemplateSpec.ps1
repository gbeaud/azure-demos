#Requires -Version 5.1
#Requires -Modules Az.Accounts, Az.Resources

<#
.SYNOPSIS
    Backs up the configuration of Azure resource groups as versioned template specs.

.DESCRIPTION
    Exports the resources of Azure resource groups as ARM templates and stores each export as a new
    version of a template spec, in the resource group that it describes. Template specs are versioned
    and access-controlled Azure resources: each backup can be reviewed and redeployed directly from
    the Azure portal, Azure PowerShell or the Azure CLI.

    For each resource group in scope, the script:
      1. Lists the resources of the resource group, excluding template specs and their versions.
      2. Exports these resources as an ARM template, without parameterization.
      3. Publishes the template as a new version of the template spec 'ts-<resource group name>',
         stored in the resource group itself, in the same region.
      4. Deletes the versions of this template spec that are older than the retention period.

    The scope can be the entire tenant (default), entire subscriptions or selected resource groups.
    A failure on a subscription or on a resource group is reported and does not stop the backup of
    the others. The script can run on demand from a workstation, or on a schedule from an Azure
    Automation account (recommended), an Azure DevOps pipeline or a GitHub Actions workflow.

.PARAMETER Scope
    The subscriptions and resource groups to back up. When omitted, the script backs up every
    resource group of every subscription that the signed-in identity can access.

    Specify a hashtable, or the equivalent JSON object, whose keys are subscription IDs or names and
    whose values are either:
      - $null (null in JSON), to back up every resource group of the subscription.
      - One or more resource group names, to back up only these resource groups.

    Azure Automation passes runbook parameters as JSON: enter the scope as a JSON object, such as
    {"00000000-0000-0000-0000-000000000000": ["rg-app-prod-01"], "Production": null}.

.PARAMETER RetentionDays
    The retention period of the template spec versions, in days. After each successful backup, the
    versions of the template spec that are older than this period are deleted. The default value is
    365.

.PARAMETER UseManagedIdentity
    Signs in to Azure with the managed identity of the host, such as an Azure Automation account,
    before running the backup. When omitted, the script uses the current Azure PowerShell context:
    sign in first with Connect-AzAccount.

.EXAMPLE
    PS> .\Backup-AzResourceGroupToTemplateSpec.ps1 -Verbose

    Backs up every resource group of every subscription that the signed-in identity can access, and
    keeps the template spec versions of the last 365 days.

.EXAMPLE
    PS> $scope = @{
            '00000000-0000-0000-0000-000000000000' = 'rg-app-prod-01', 'rg-app-prod-02'
            'Production'                           = $null
        }
    PS> .\Backup-AzResourceGroupToTemplateSpec.ps1 -Scope $scope -RetentionDays 90

    Backs up two resource groups of the first subscription and every resource group of the
    'Production' subscription, and keeps the template spec versions of the last 90 days.

.EXAMPLE
    PS> .\Backup-AzResourceGroupToTemplateSpec.ps1 -Scope @{ 'Production' = $null } -WhatIf

    Shows the backups that would be performed in the 'Production' subscription, without exporting or
    deleting anything.

.EXAMPLE
    PS> $results = .\Backup-AzResourceGroupToTemplateSpec.ps1
    PS> $results | Where-Object -Property Status -EQ 'Failed' | Format-List -Property *

    Backs up the entire tenant, then displays the details of the resource groups that could not be
    backed up.

.EXAMPLE
    PS> $schedule = @{
            ResourceGroupName     = 'rg-automation-prod'
            AutomationAccountName = 'aa-backup-prod'
            RunbookName           = 'Backup-AzResourceGroupToTemplateSpec'
            ScheduleName          = 'Daily'
            Parameters            = @{
                Scope              = '{"00000000-0000-0000-0000-000000000000": ["rg-app-prod-01"], "Production": null}'
                RetentionDays      = 365
                UseManagedIdentity = $true
            }
        }
    PS> Register-AzAutomationScheduledRunbook @schedule

    Links the runbook to the 'Daily' schedule of an Azure Automation account. The backup runs with
    the managed identity of the Automation account.

.INPUTS
    None. You cannot pipe objects to this script.

.OUTPUTS
    AzureBackup.ResourceGroupTemplateSpecResult
        One object per resource group, with the SubscriptionId, SubscriptionName, ResourceGroupName,
        TemplateSpecName, TemplateSpecVersion, ResourceCount, RemovedVersions, Status (Succeeded,
        Skipped or Failed) and Message properties.

.NOTES
    Author       : Guillaume Beaud (Microsoft Cloud Solution Architect)
    Version      : 2.0.0
    Last updated : November 2026

    Requirements
      - The Az.Accounts and Az.Resources PowerShell modules.
      - On the subscriptions or resource groups in scope: the Contributor role, or a custom role that
        grants read access to the resources and the
        Microsoft.Resources/subscriptions/resourceGroups/exportTemplate/action and
        Microsoft.Resources/templateSpecs/* permissions.
      - In Azure Automation: a managed identity with these permissions, and the UseManagedIdentity
        parameter. Enable "Log verbose records" on the runbook to log the progress of the backup.

    Naming
      Template spec names and version names are limited to 90 characters. The template spec name is
      'ts-' followed by the first 81 characters of the resource group name. The version name is the
      first 71 characters of the resource group name, followed by the time of the backup
      (yyyy-MM-dd-HH-mm, in the local time of the host; Azure Automation runs in UTC).

    Known limitations
      Azure Resource Manager cannot export some resource types and properties. In that case,
      Export-AzResourceGroup returns the warning ExportTemplateCompletedWithErrors and the template
      does not fully describe these resources: review the template before relying on it.

.LINK
    https://learn.microsoft.com/azure/azure-resource-manager/templates/template-specs

.LINK
    https://learn.microsoft.com/powershell/module/az.resources/export-azresourcegroup
#>

[CmdletBinding(SupportsShouldProcess)]
[OutputType('AzureBackup.ResourceGroupTemplateSpecResult')]
param (
    [Parameter()]
    [object]$Scope,

    [Parameter()]
    [ValidateRange(1, 36500)]
    [int]$RetentionDays = 365,

    [Parameter()]
    [switch]$UseManagedIdentity
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region Helper functions

function Connect-AzureSession {
    <#
    .SYNOPSIS
        Ensures that an Azure context is available, after signing in with the managed identity of the
        host if requested.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]$UseManagedIdentity
    )

    if ($UseManagedIdentity) {
        Write-Verbose -Message 'Signing in to Azure with the managed identity...'
        # Prevents the runbook from inheriting or persisting an Azure context.
        $null = Disable-AzContextAutosave -Scope Process -WhatIf:$false -Confirm:$false
        $context = (Connect-AzAccount -Identity -WhatIf:$false -Confirm:$false).Context
    }
    else {
        $context = Get-AzContext
    }

    if ($null -eq $context -or $null -eq $context.Account) {
        throw 'No Azure context is available. Sign in with Connect-AzAccount, or use the UseManagedIdentity parameter in Azure Automation.'
    }

    Write-Verbose -Message "Signed in to Azure as '$($context.Account.Id)'."
}

function Resolve-BackupScope {
    <#
    .SYNOPSIS
        Converts the Scope parameter into the list of subscriptions and resource groups to back up.
    .OUTPUTS
        One object per subscription, with the Subscription, TenantId and ResourceGroupNames
        properties. ResourceGroupNames is $null when every resource group of the subscription must be
        backed up.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter()]
        [object]$Scope
    )

    if ($null -eq $Scope -or ($Scope -is [string] -and [string]::IsNullOrWhiteSpace($Scope))) {
        Write-Verbose -Message 'No scope specified: backing up every subscription that the signed-in identity can access.'
        foreach ($subscription in @(Get-AzSubscription)) {
            [pscustomobject]@{
                Subscription       = $subscription.Id
                TenantId           = $subscription.TenantId
                ResourceGroupNames = $null
            }
        }
        return
    }

    # Azure Automation passes the parameters of a runbook as JSON.
    if ($Scope -is [string]) {
        try {
            $Scope = ConvertFrom-Json -InputObject $Scope
        }
        catch {
            throw "The Scope parameter is not a valid JSON object: $($_.Exception.Message)"
        }
    }

    if ($Scope -is [System.Management.Automation.PSCustomObject]) {
        $scopeTable = [ordered]@{}
        foreach ($property in $Scope.PSObject.Properties) {
            $scopeTable[$property.Name] = $property.Value
        }
        $Scope = $scopeTable
    }

    if ($Scope -isnot [System.Collections.IDictionary]) {
        throw 'The Scope parameter must be a hashtable or a JSON object whose keys are subscription IDs or names.'
    }

    if ($Scope.Count -eq 0) {
        Write-Warning -Message 'The Scope parameter does not contain any subscription: there is nothing to back up.'
        return
    }

    foreach ($entry in $Scope.GetEnumerator()) {
        $resourceGroupNames = $null
        if ($null -ne $entry.Value) {
            $resourceGroupNames = [string[]]@(
                $entry.Value |
                    ForEach-Object -Process { ([string]$_).Trim() } |
                    Where-Object -FilterScript { $_ }
            )
            if ($resourceGroupNames.Count -eq 0) {
                Write-Warning -Message "The Scope parameter does not contain any resource group for subscription '$($entry.Key)': the subscription is skipped."
                continue
            }
        }

        [pscustomobject]@{
            Subscription       = [string]$entry.Key
            TenantId           = $null
            ResourceGroupNames = $resourceGroupNames
        }
    }
}

function Get-TruncatedString {
    <#
    .SYNOPSIS
        Returns the first characters of a string, up to the specified maximum length.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$InputString,

        [Parameter(Mandatory)]
        [ValidateRange(1, 90)]
        [int]$MaxLength
    )

    $InputString.Substring(0, [System.Math]::Min($InputString.Length, $MaxLength))
}

function Remove-ExpiredTemplateSpecVersion {
    <#
    .SYNOPSIS
        Removes the versions of a template spec that are older than the retention period, and returns
        the names of the removed versions.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory)]
        [string]$TemplateSpecName,

        [Parameter(Mandatory)]
        [int]$RetentionDays
    )

    $expirationDate = [datetime]::UtcNow.AddDays(-$RetentionDays)
    $templateSpec = Get-AzTemplateSpec -ResourceGroupName $ResourceGroupName -Name $TemplateSpecName

    foreach ($version in $templateSpec.Versions) {
        if ($null -eq $version.CreationTime -or $version.CreationTime.ToUniversalTime() -ge $expirationDate) {
            continue
        }

        if ($PSCmdlet.ShouldProcess("$TemplateSpecName/$($version.Name)", 'Remove expired template spec version')) {
            try {
                $removeParameters = @{
                    ResourceGroupName = $ResourceGroupName
                    Name              = $TemplateSpecName
                    Version           = $version.Name
                    Force             = $true
                    Confirm           = $false
                }
                $null = Remove-AzTemplateSpec @removeParameters
                Write-Verbose -Message "Removed expired template spec version '$TemplateSpecName/$($version.Name)'."
                $version.Name
            }
            catch {
                $errorMessage = "Failed to remove template spec version '$TemplateSpecName/$($version.Name)': $($_.Exception.Message)"
                Write-Error -Message $errorMessage -Exception $_.Exception -TargetObject $version.Name -ErrorAction Continue
            }
        }
    }
}

function Backup-ResourceGroupToTemplateSpec {
    <#
    .SYNOPSIS
        Backs up the resources of a resource group as a new template spec version, then removes the
        expired versions of the template spec.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([pscustomobject])]
    param (
        [Parameter(Mandatory)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory)]
        [int]$RetentionDays,

        [Parameter(Mandatory)]
        [string]$SubscriptionId,

        [Parameter(Mandatory)]
        [string]$SubscriptionName
    )

    $excludedResourceTypes = @(
        'Microsoft.Resources/templateSpecs'
        'Microsoft.Resources/templateSpecs/versions'
    )
    $timestamp = [datetime]::Now.ToString('yyyy-MM-dd-HH-mm', [cultureinfo]::InvariantCulture)
    $templateSpecName = 'ts-{0}' -f (Get-TruncatedString -InputString $ResourceGroupName -MaxLength 81)
    $templateSpecVersion = '{0}_{1}' -f (Get-TruncatedString -InputString $ResourceGroupName -MaxLength 71), $timestamp

    $result = [pscustomobject]@{
        PSTypeName          = 'AzureBackup.ResourceGroupTemplateSpecResult'
        SubscriptionId      = $SubscriptionId
        SubscriptionName    = $SubscriptionName
        ResourceGroupName   = $ResourceGroupName
        TemplateSpecName    = $templateSpecName
        TemplateSpecVersion = $templateSpecVersion
        ResourceCount       = 0
        RemovedVersions     = [string[]]@()
        Status              = 'Skipped'
        Message             = ''
    }

    try {
        Write-Verbose -Message "Processing resource group '$ResourceGroupName'..."
        $resourceIds = @(
            Get-AzResource -ResourceGroupName $ResourceGroupName |
                Where-Object -Property ResourceType -NotIn $excludedResourceTypes |
                Select-Object -ExpandProperty ResourceId
        )
        $result.ResourceCount = $resourceIds.Count
        $operation = "Back up $($resourceIds.Count) resource(s) to template spec version '$templateSpecName/$templateSpecVersion'"

        if ($resourceIds.Count -eq 0) {
            $result.Message = 'The resource group contains no resources to back up.'
        }
        elseif ($PSCmdlet.ShouldProcess($ResourceGroupName, $operation)) {
            $templateFilePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "$templateSpecVersion.json"
            try {
                $exportParameters = @{
                    ResourceGroupName       = $ResourceGroupName
                    Resource                = $resourceIds
                    Path                    = $templateFilePath
                    SkipAllParameterization = $true
                    Force                   = $true
                    Confirm                 = $false
                }
                $null = Export-AzResourceGroup @exportParameters

                $templateSpecParameters = @{
                    ResourceGroupName = $ResourceGroupName
                    Name              = $templateSpecName
                    Version           = $templateSpecVersion
                    Location          = (Get-AzResourceGroup -Name $ResourceGroupName).Location
                    TemplateFile      = $templateFilePath
                    Force             = $true
                    Confirm           = $false
                }
                $null = New-AzTemplateSpec @templateSpecParameters
            }
            finally {
                if (Test-Path -LiteralPath $templateFilePath) {
                    Remove-Item -LiteralPath $templateFilePath -Force -Confirm:$false -ErrorAction SilentlyContinue
                }
            }

            $result.Status = 'Succeeded'
            $result.Message = "Exported $($resourceIds.Count) resource(s) to template spec version '$templateSpecVersion'."
        }
        else {
            $result.Message = 'Backup not performed: the operation was not confirmed or WhatIf was specified.'
        }
    }
    catch {
        $result.Status = 'Failed'
        $result.Message = $_.Exception.Message
        $errorMessage = "Failed to back up resource group '$ResourceGroupName' of subscription '$SubscriptionName': $($_.Exception.Message)"
        Write-Error -Message $errorMessage -Exception $_.Exception -TargetObject $ResourceGroupName -ErrorAction Continue
    }

    if ($result.Status -eq 'Succeeded') {
        try {
            $retentionParameters = @{
                ResourceGroupName = $ResourceGroupName
                TemplateSpecName  = $templateSpecName
                RetentionDays     = $RetentionDays
            }
            $result.RemovedVersions = [string[]]@(Remove-ExpiredTemplateSpecVersion @retentionParameters)
            if ($result.RemovedVersions.Count -gt 0) {
                $result.Message += " Removed $($result.RemovedVersions.Count) expired version(s)."
            }
        }
        catch {
            $result.Message += " Expired versions could not be removed: $($_.Exception.Message)"
            $errorMessage = "Failed to remove the expired versions of template spec '$templateSpecName' in resource group '$ResourceGroupName': $($_.Exception.Message)"
            Write-Error -Message $errorMessage -Exception $_.Exception -TargetObject $templateSpecName -ErrorAction Continue
        }
    }

    $result
}

#endregion

#region Main

$typeDataParameters = @{
    TypeName                  = 'AzureBackup.ResourceGroupTemplateSpecResult'
    DefaultDisplayPropertySet = 'SubscriptionName', 'ResourceGroupName', 'Status', 'Message'
    Force                     = $true
    WhatIf                    = $false
    Confirm                   = $false
}
Update-TypeData @typeDataParameters

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$statusCounts = @{ Succeeded = 0; Skipped = 0; Failed = 0 }
$failedSubscriptionCount = 0

try {
    Connect-AzureSession -UseManagedIdentity:$UseManagedIdentity
    $backupScopes = @(Resolve-BackupScope -Scope $Scope)
}
catch {
    $PSCmdlet.ThrowTerminatingError($_)
}

foreach ($backupScope in $backupScopes) {
    try {
        $contextParameters = @{
            Subscription = $backupScope.Subscription
            WhatIf       = $false
            Confirm      = $false
        }
        if ($backupScope.TenantId) {
            $contextParameters['Tenant'] = $backupScope.TenantId
        }
        $subscription = (Set-AzContext @contextParameters).Subscription
        Write-Verbose -Message "Processing subscription '$($subscription.Name)' ($($subscription.Id))..."

        $resourceGroupNames = $backupScope.ResourceGroupNames
        if ($null -eq $resourceGroupNames) {
            $resourceGroupNames = @(Get-AzResourceGroup | Select-Object -ExpandProperty ResourceGroupName)
        }
    }
    catch {
        $failedSubscriptionCount++
        $errorMessage = "Failed to process subscription '$($backupScope.Subscription)': $($_.Exception.Message)"
        Write-Error -Message $errorMessage -Exception $_.Exception -TargetObject $backupScope.Subscription -ErrorAction Continue
        continue
    }

    foreach ($resourceGroupName in $resourceGroupNames) {
        $backupParameters = @{
            ResourceGroupName = $resourceGroupName
            RetentionDays     = $RetentionDays
            SubscriptionId    = $subscription.Id
            SubscriptionName  = $subscription.Name
        }
        $result = Backup-ResourceGroupToTemplateSpec @backupParameters
        $statusCounts[$result.Status]++
        $result
    }
}

$stopwatch.Stop()
$summary = 'Backup completed in {0:hh\:mm\:ss}: {1} succeeded, {2} skipped, {3} failed.' -f @(
    $stopwatch.Elapsed, $statusCounts.Succeeded, $statusCounts.Skipped, $statusCounts.Failed
)
Write-Verbose -Message $summary

if ($statusCounts.Failed -gt 0 -or $failedSubscriptionCount -gt 0) {
    Write-Warning -Message "The backup completed with errors: $($statusCounts.Failed) resource group(s) and $failedSubscriptionCount subscription(s) failed. See the error stream for details."
}

#endregion
