# First, ensure you're logged in to Azure
Connect-AzAccount

# Select subscription (Sandbox - new tenant Sweden Central)
Set-AzContext -Subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX

# Run the verification
.\Verify-Policy.ps1 -ResourceGroupName "rg-policy-vm-script-dev-swec-01" -VMName "vm-win-demo-01"

# Run the verification manually using Run Command in Azure for Windows
Get-ChildItem -Path "C:\" -Force

# Run the verification manually using Run Command in Azure for Linux
ls -la /