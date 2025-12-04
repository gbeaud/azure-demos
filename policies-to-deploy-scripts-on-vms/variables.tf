variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "swedencentral"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-vm-demo-swec-01"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-demo-swec-01"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the default subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_name" {
  description = "Name of the Windows virtual machine"
  type        = string
  default     = "vm-win-demo-01"
}

variable "vm_size" {
  description = "Size of the Windows virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_zone" {
  description = "Availability zone for the VMs"
  type        = string
  default     = "1"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "adminuser"
}

variable "windows_sku" {
  description = "Windows Server SKU"
  type        = string
  default     = "2022-datacenter-azure-edition"
}

variable "os_disk_type" {
  description = "OS disk storage account type"
  type        = string
  default     = "Standard_LRS"
}

variable "allowed_source_ip" {
  description = "Source IP allowed to RDP/SSH to the VMs"
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

# =============================================================================
# LINUX VM VARIABLES
# =============================================================================

variable "linux_vm_name" {
  description = "Name of the Linux virtual machine"
  type        = string
  default     = "vm-linux-demo-01"
}

variable "linux_vm_size" {
  description = "Size of the Linux virtual machine"
  type        = string
  default     = "Standard_B1s"
}

# =============================================================================
# WINDOWS POLICY VARIABLES
# =============================================================================

variable "policy_definition_name" {
  description = "Name of the Windows policy definition"
  type        = string
  default     = "deploy-hello-folder-windows-vm"
}

variable "policy_assignment_name" {
  description = "Name of the Windows policy assignment"
  type        = string
  default     = "assign-hello-folder-windows"
}

# =============================================================================
# LINUX POLICY VARIABLES
# =============================================================================

variable "linux_policy_definition_name" {
  description = "Name of the Linux policy definition"
  type        = string
  default     = "deploy-hello-folder-linux-vm"
}

variable "linux_policy_assignment_name" {
  description = "Name of the Linux policy assignment"
  type        = string
  default     = "assign-hello-folder-linux"
}