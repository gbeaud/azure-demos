# First, ensure you're logged in to Azure
Connect-AzAccount

# Select subscription (Sandbox - new tenant Sweden Central)
Set-AzContext -Subscription 3ef3978c-b123-4b9b-92cd-15d940a22dc9

# Run the verification
.\Verify-Policy.ps1 -ResourceGroupName "rg-policy-vm-script-dev-swec-01" -VMName "vm-win-demo-01"

# Run the verification manually using Run Command in Azure
Get-ChildItem -Path "C:\" -Force