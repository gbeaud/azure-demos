location              = "swedencentral"
resource_group_name   = "rg-policy-vm-script-dev-swec-01"
vnet_name             = "vnet-demo-swec-01"

# Windows VM settings
vm_name               = "vm-win-demo-01"
vm_size               = "Standard_B2s"
windows_sku           = "2022-datacenter-azure-edition"

# Linux VM settings
linux_vm_name         = "vm-linux-demo-01"
linux_vm_size         = "Standard_B1s"

allowed_source_ip     = "*"  # Replace with your IP for security

# Windows Policy settings
policy_definition_name = "deploy-hello-folder-windows-vm"
policy_assignment_name = "assign-hello-folder-windows"

# Linux Policy settings
linux_policy_definition_name = "deploy-hello-folder-linux-vm"
linux_policy_assignment_name = "assign-hello-folder-linux"

tags = {
  Environment = "Demo"
  ManagedBy   = "Terraform"
}