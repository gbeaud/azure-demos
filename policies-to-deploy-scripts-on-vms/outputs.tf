output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

# =============================================================================
# WINDOWS VM OUTPUTS
# =============================================================================

output "windows_vm_name" {
  description = "Name of the Windows virtual machine"
  value       = module.windows_vm.name
}

output "windows_vm_id" {
  description = "Resource ID of the Windows virtual machine"
  value       = module.windows_vm.resource_id
}

output "windows_public_ip_address" {
  description = "Public IP address of the Windows VM"
  value       = azurerm_public_ip.windows.ip_address
}

output "admin_username" {
  description = "Admin username for the VMs"
  value       = var.admin_username
}

output "admin_password" {
  description = "Admin password for the Windows VM"
  value       = random_password.admin_password.result
  sensitive   = true
}

# =============================================================================
# LINUX VM OUTPUTS
# =============================================================================

output "linux_vm_name" {
  description = "Name of the Linux virtual machine"
  value       = module.linux_vm.name
}

output "linux_vm_id" {
  description = "Resource ID of the Linux virtual machine"
  value       = module.linux_vm.resource_id
}

output "linux_public_ip_address" {
  description = "Public IP address of the Linux VM"
  value       = azurerm_public_ip.linux.ip_address
}

output "linux_ssh_private_key" {
  description = "SSH private key for the Linux VM"
  value       = tls_private_key.linux_ssh.private_key_pem
  sensitive   = true
}

# =============================================================================
# NETWORK OUTPUTS
# =============================================================================

output "vnet_id" {
  description = "Resource ID of the virtual network"
  value       = module.vnet.resource_id
}

output "subnet_id" {
  description = "Resource ID of the default subnet"
  value       = module.vnet.subnets["default"].resource_id
}

# =============================================================================
# WINDOWS POLICY OUTPUTS
# =============================================================================

output "windows_policy_definition_id" {
  description = "Resource ID of the Windows policy definition"
  value       = azurerm_policy_definition.deploy_hello_folder_windows.id
}

output "windows_policy_assignment_id" {
  description = "Resource ID of the Windows policy assignment"
  value       = azurerm_resource_group_policy_assignment.deploy_hello_folder_windows.id
}

# =============================================================================
# LINUX POLICY OUTPUTS
# =============================================================================

output "linux_policy_definition_id" {
  description = "Resource ID of the Linux policy definition"
  value       = azurerm_policy_definition.deploy_hello_folder_linux.id
}

output "linux_policy_assignment_id" {
  description = "Resource ID of the Linux policy assignment"
  value       = azurerm_resource_group_policy_assignment.deploy_hello_folder_linux.id
}