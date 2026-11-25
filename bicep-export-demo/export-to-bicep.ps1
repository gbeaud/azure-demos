<#
.SYNOPSIS
    Exports existing resource groups to Bicep: one folder per resource group containing the raw
    ARM export, the decompiled Bicep, and the extension resources that the export does not capture
    (role assignments, diagnostic settings, locks, policy assignments).

.DESCRIPTION
    Deterministic: no AI involved. The output is raw material to be refactored (e.g. with GitHub Copilot), not production-ready code.
    Note: 'az group export' supports at most 200 resources per resource group.

.EXAMPLE
    ./export-to-bicep.ps1 -ResourceGroupNames rg-bicep-export-demo-swec-01

.EXAMPLE
    # All resource groups of the subscription
    ./export-to-bicep.ps1 -SubscriptionName sub-general-demos-swec-01 -OutputPath ./bicep-generated-by-script
#>
param(
    [string]$SubscriptionName = "sub-general-demos-swec-01",
    # Leave empty to export every resource group in the subscription
    [string[]]$ResourceGroupNames = @(),
    [string]$OutputPath = (Join-Path $PSScriptRoot "bicep-generated-by-script")
)

$ErrorActionPreference = "Stop"
# az emits warnings/partial errors on export and decompile; exit codes are checked explicitly
$PSNativeCommandUseErrorActionPreference = $false

az account set --subscription $SubscriptionName
if ($LASTEXITCODE -ne 0) { throw "Cannot select subscription $SubscriptionName" }

if ($ResourceGroupNames.Count -eq 0) {
    $ResourceGroupNames = az group list --query "[?managedBy==null].name" -o tsv
}

# Child resources that have their own diagnostic settings
$diagSubResources = @{
    "Microsoft.Storage/storageAccounts" = @("blobServices/default", "fileServices/default", "queueServices/default", "tableServices/default")
}

function Save-Json($Value, $Path) {
    ConvertTo-Json -InputObject @($Value) -Depth 20 | Set-Content -Path $Path -Encoding utf8
}

# 'az role assignment list -g' omits assignments scoped to individual resources, so list once and filter per RG
Write-Host "Listing role assignments in the subscription..."
$allRoleAssignments = az role assignment list --all -o json | ConvertFrom-Json

$summary = foreach ($rg in $ResourceGroupNames) {
    Write-Host "`n=== $rg ===" -ForegroundColor Cyan
    $rgDir = Join-Path $OutputPath $rg
    New-Item -ItemType Directory -Path $rgDir -Force | Out-Null

    $templateFile = Join-Path $rgDir "main.json"
    $exportLog    = Join-Path $rgDir "export-errors.txt"
    $decompileLog = Join-Path $rgDir "decompile-errors.txt"

    Write-Host "Exporting ARM template..."
    az group export -n $rg --skip-all-params 2> $exportLog | Set-Content -Path $templateFile -Encoding utf8
    if (-not (Get-Content $templateFile -Raw)) {
        Write-Warning "Export failed for $rg, see $exportLog"
        continue
    }

    Write-Host "Decompiling to Bicep..."
    az bicep decompile --file $templateFile --force *> $decompileLog
    # Strip the local absolute path so the log can be committed
    $rgFullPath = (Resolve-Path $rgDir).Path + [IO.Path]::DirectorySeparatorChar
    (Get-Content $decompileLog -Raw).Replace($rgFullPath, '') | Set-Content -Path $decompileLog -Encoding utf8
    $bicepFile = Join-Path $rgDir "main.bicep"

    Write-Host "Collecting role assignments, locks, policy assignments..."
    # Only assignments scoped to this RG or its resources (not inherited from subscription / MG)
    $roles = @($allRoleAssignments | Where-Object { $_.scope -like "*/resourceGroups/$rg" -or $_.scope -like "*/resourceGroups/$rg/*" })
    Save-Json $roles (Join-Path $rgDir "role-assignments.json")
    Save-Json @(az lock list -g $rg -o json | ConvertFrom-Json) (Join-Path $rgDir "locks.json")
    $policies = az policy assignment list -g $rg -o json | ConvertFrom-Json
    Save-Json @($policies | Where-Object { $_.scope -like "*/resourceGroups/$rg" -or $_.scope -like "*/resourceGroups/$rg/*" }) `
        (Join-Path $rgDir "policy-assignments.json")

    Write-Host "Collecting diagnostic settings..."
    $diagSettings = foreach ($res in (az resource list -g $rg --query "[].{id:id,type:type}" -o json | ConvertFrom-Json)) {
        $targets = @($res.id) + @($diagSubResources[$res.type] | Where-Object { $_ } | ForEach-Object { "$($res.id)/$_" })
        foreach ($target in $targets) {
            $result = az monitor diagnostic-settings list --resource $target -o json 2>$null
            if ($LASTEXITCODE -eq 0 -and $result) {
                $parsed = $result | ConvertFrom-Json
                # Older az versions wrap results in a "value" property
                if ($parsed.PSObject.Properties.Name -contains "value") { $parsed = $parsed.value }
                $parsed
            }
        }
    }
    Save-Json @($diagSettings) (Join-Path $rgDir "diagnostic-settings.json")

    $bicepErrors = @(Select-String -Path $decompileLog -Pattern "Error BCP" -ErrorAction SilentlyContinue).Count
    [pscustomobject]@{
        ResourceGroup      = $rg
        ExportedResources  = (Get-Content $templateFile -Raw | ConvertFrom-Json).resources.Count
        BicepLines         = if (Test-Path $bicepFile) { (Get-Content $bicepFile).Count } else { 0 }
        BicepErrors        = $bicepErrors
        RoleAssignments    = $roles.Count
        DiagnosticSettings = @($diagSettings).Count
    }
}

Write-Host "`nExport written to $OutputPath" -ForegroundColor Green
$summary | Format-Table -AutoSize
