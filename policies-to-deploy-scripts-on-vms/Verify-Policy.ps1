<#
.SYNOPSIS
    Verifies if the 'hello' folder has been created on a Windows VM.

.DESCRIPTION
    This script connects to an Azure VM and checks if the C:\hello folder exists.
    It can run the check either via Azure Run Command or by connecting directly via RDP/WinRM.

.PARAMETER ResourceGroupName
    The name of the resource group containing the VM.

.PARAMETER VMName
    The name of the virtual machine to check.

.PARAMETER UseRunCommand
    If specified, uses Azure Run Command to execute the check remotely.

.EXAMPLE
    .\verify-hello-folder.ps1 -ResourceGroupName "rg-policy-vm-script-dev-swec-01" -VMName "vm-win-demo-01"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$VMName,

    [Parameter(Mandatory = $false)]
    [switch]$UseRunCommand = $true
)

# Script to run on the VM
$scriptToRun = @'
$folderPath = "C:\hello"

if (Test-Path -Path $folderPath) {
    $folder = Get-Item -Path $folderPath
    Write-Output "SUCCESS: Folder 'hello' exists!"
    Write-Output "  Path: $($folder.FullName)"
    Write-Output "  Created: $($folder.CreationTime)"
    Write-Output "  Last Modified: $($folder.LastWriteTime)"
    exit 0
} else {
    Write-Output "FAILURE: Folder 'hello' does NOT exist at $folderPath"
    exit 1
}
'@

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Verifying 'hello' folder on VM: $VMName" -ForegroundColor Cyan
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check if logged in to Azure
$context = Get-AzContext -ErrorAction SilentlyContinue
if (-not $context) {
    Write-Host "Not logged in to Azure. Please run Connect-AzAccount first." -ForegroundColor Red
    exit 1
}

Write-Host "Using Azure subscription: $($context.Subscription.Name)" -ForegroundColor Gray
Write-Host ""

# Verify VM exists
Write-Host "Checking if VM exists..." -ForegroundColor Yellow
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -ErrorAction SilentlyContinue
if (-not $vm) {
    Write-Host "ERROR: VM '$VMName' not found in resource group '$ResourceGroupName'" -ForegroundColor Red
    exit 1
}
Write-Host "VM found: $($vm.Name) (OS: $($vm.StorageProfile.OsDisk.OsType))" -ForegroundColor Green
Write-Host ""

# Check VM power state
$vmStatus = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Status
$powerState = ($vmStatus.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus
Write-Host "VM Power State: $powerState" -ForegroundColor Gray

if ($powerState -ne "VM running") {
    Write-Host "WARNING: VM is not running. Cannot execute remote command." -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Execute the verification script using Run Command
Write-Host "Executing verification script on VM using Run Command..." -ForegroundColor Yellow
Write-Host ""

try {
    $result = Invoke-AzVMRunCommand `
        -ResourceGroupName $ResourceGroupName `
        -VMName $VMName `
        -CommandId 'RunPowerShellScript' `
        -ScriptString $scriptToRun `
        -ErrorAction Stop

    # Display the output
    Write-Host "--- VM Output ---" -ForegroundColor Cyan
    foreach ($output in $result.Value) {
        if ($output.Code -eq "ComponentStatus/StdOut/succeeded") {
            Write-Host $output.Message -ForegroundColor Green
        }
        elseif ($output.Code -eq "ComponentStatus/StdErr/succeeded" -and $output.Message) {
            Write-Host $output.Message -ForegroundColor Red
        }
    }
    Write-Host "--- End Output ---" -ForegroundColor Cyan
    Write-Host ""

    # Check if folder exists based on output
    $stdOut = ($result.Value | Where-Object { $_.Code -eq "ComponentStatus/StdOut/succeeded" }).Message
    if ($stdOut -match "SUCCESS") {
        Write-Host "VERIFICATION PASSED: The 'hello' folder exists on the VM!" -ForegroundColor Green
        exit 0
    }
    else {
        Write-Host "VERIFICATION FAILED: The 'hello' folder was NOT found on the VM." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "ERROR: Failed to execute Run Command on VM." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}