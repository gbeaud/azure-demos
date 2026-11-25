<#
.SYNOPSIS
    Runs what-if, deploys, or deploys as a deployment stack a Bicep template to a resource group.

.EXAMPLE
    # Preview changes (default)
    ./deploy-bicep.ps1

.EXAMPLE
    # Deploy after showing what-if and asking for confirmation
    ./deploy-bicep.ps1 -Mode Deploy

.EXAMPLE
    # Deploy as a deployment stack that blocks out-of-band changes
    ./deploy-bicep.ps1 -Mode Stack -DenySettingsMode denyWriteAndDelete

.EXAMPLE
    # Preview with deployment stack what-if (less noise once the stack has been deployed)
    ./deploy-bicep.ps1 -Mode StackWhatIf
#>
param(
    [string]$SubscriptionName = "sub-general-demos-swec-01",
    [string]$ResourceGroupName = "rg-bicep-export-demo-swec-01",
    [string]$TemplateFile = (Join-Path $PSScriptRoot "bicep-refactored-by-ai-with-avm/main.bicep"),
    # Defaults to the .bicepparam next to the template if it exists
    [string]$ParametersFile,
    [ValidateSet("WhatIf", "Deploy", "Stack", "StackWhatIf")]
    [string]$Mode = "WhatIf",
    # Deploy / Stack: skip the confirmation prompt
    [switch]$Force,
    # Stack / StackWhatIf only
    [ValidateSet("none", "denyDelete", "denyWriteAndDelete")]
    [string]$DenySettingsMode = "none",
    # Stack / StackWhatIf only: what happens to resources removed from the template
    [ValidateSet("detachAll", "deleteResources", "deleteAll")]
    [string]$ActionOnUnmanage = "detachAll"
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

if (-not $ParametersFile) {
    $candidate = [IO.Path]::ChangeExtension($TemplateFile, ".bicepparam")
    if (Test-Path $candidate) { $ParametersFile = $candidate }
}

az account set --subscription $SubscriptionName

$common = @("-g", $ResourceGroupName, "--template-file", $TemplateFile)
if ($ParametersFile) { $common += @("--parameters", $ParametersFile) }
$deploymentName = "bicep-export-demo-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$stackName = "stack-$ResourceGroupName"
$stackArgs = @("--action-on-unmanage", $ActionOnUnmanage, "--deny-settings-mode", $DenySettingsMode)

# Diffs against the baseline Azure stores at each stack deployment, which hides most what-if noise
function Invoke-StackWhatIf {
    $subscriptionId = az account show --query id -o tsv
    $stackId = "/subscriptions/$subscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Resources/deploymentStacks/$stackName"
    az stack-whatif group create @common @stackArgs -n $deploymentName --stack-id $stackId --retention-interval P1D
}

Write-Host "Template:   $TemplateFile"
Write-Host "Parameters: $(if ($ParametersFile) { $ParametersFile } else { '(none)' })"
Write-Host "Target:     $SubscriptionName / $ResourceGroupName"
Write-Host "Mode:       $Mode`n"

switch ($Mode) {
    "WhatIf" {
        az deployment group what-if @common --result-format FullResourcePayloads
    }
    "Deploy" {
        # @() keeps an array: a single-item array returned by 'if' is unwrapped to a string, which splats per character
        $confirm = @(if (-not $Force) { "--confirm-with-what-if" })
        az deployment group create @common -n $deploymentName @confirm --query properties.outputs -o json
    }
    "StackWhatIf" {
        Invoke-StackWhatIf
    }
    "Stack" {
        if (-not $Force) {
            Invoke-StackWhatIf
            if ((Read-Host "Deploy as deployment stack? (y/N)") -ne "y") { return }
        }
        az stack group create @common @stackArgs -n $stackName --yes --query provisioningState -o tsv
        Write-Host "Managed resources:"
        az stack group show -g $ResourceGroupName -n $stackName --query "resources[].id" -o tsv
    }
}
