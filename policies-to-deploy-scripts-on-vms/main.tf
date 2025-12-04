terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network using AVM
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~>0.4.0"

  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  name                          = var.vnet_name
  address_space                 = var.vnet_address_space
  
  subnets = {
    default = {
      name             = "snet-default"
      address_prefixes = [var.subnet_address_prefix]
    }
  }

  tags = var.tags
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "nsg-vms"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.allowed_source_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_source_ip
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = module.vnet.subnets["default"].resource_id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Public IP for Windows VM
resource "azurerm_public_ip" "windows" {
  name                = "pip-${var.vm_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Public IP for Linux VM
resource "azurerm_public_ip" "linux" {
  name                = "pip-${var.linux_vm_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Generate random password for VM admin
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

# Generate SSH key for Linux VM
resource "tls_private_key" "linux_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Windows VM using AVM
module "windows_vm" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~>0.15.0"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.vm_name
  zone                = var.vm_zone

  admin_username                  = var.admin_username
  admin_password                  = random_password.admin_password.result
  disable_password_authentication = false

  os_type  = "Windows"
  sku_size = var.vm_size

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.windows_sku
    version   = "latest"
  }

  network_interfaces = {
    network_interface_1 = {
      name = "nic-${var.vm_name}"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.vnet.subnets["default"].resource_id
          public_ip_address_resource_id = azurerm_public_ip.windows.id
        }
      }
    }
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  tags = var.tags
}

# =============================================================================
# LINUX VM using AVM
# =============================================================================

module "linux_vm" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~>0.15.0"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = var.linux_vm_name
  zone                = var.vm_zone

  admin_username                  = var.admin_username
  disable_password_authentication = true

  generate_admin_password_or_ssh_key = false
  
  admin_ssh_keys = [
    {
      public_key = tls_private_key.linux_ssh.public_key_openssh
      username   = var.admin_username
    }
  ]

  os_type  = "Linux"
  sku_size = var.linux_vm_size

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interfaces = {
    network_interface_1 = {
      name = "nic-${var.linux_vm_name}"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.vnet.subnets["default"].resource_id
          public_ip_address_resource_id = azurerm_public_ip.linux.id
        }
      }
    }
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  tags = var.tags
}

# =============================================================================
# POLICY DEFINITIONS - Load from external JSON files
# =============================================================================

locals {
  policy_definition_windows = jsondecode(file("${path.module}/policy-definition-windows.json"))
  policy_definition_linux   = jsondecode(file("${path.module}/policy-definition-linux.json"))
}

# =============================================================================
# WINDOWS POLICY DEFINITION - Load from external JSON file
# =============================================================================

resource "azurerm_policy_definition" "deploy_hello_folder_windows" {
  name         = var.policy_definition_name
  policy_type  = "Custom"
  mode         = local.policy_definition_windows.mode
  display_name = local.policy_definition_windows.displayName
  description  = local.policy_definition_windows.description

  metadata    = jsonencode(local.policy_definition_windows.metadata)
  policy_rule = jsonencode(local.policy_definition_windows.policyRule)
  parameters  = jsonencode(local.policy_definition_windows.parameters)
}

# =============================================================================
# LINUX POLICY DEFINITION - Load from external JSON file
# =============================================================================

resource "azurerm_policy_definition" "deploy_hello_folder_linux" {
  name         = var.linux_policy_definition_name
  policy_type  = "Custom"
  mode         = local.policy_definition_linux.mode
  display_name = local.policy_definition_linux.displayName
  description  = local.policy_definition_linux.description

  metadata    = jsonencode(local.policy_definition_linux.metadata)
  policy_rule = jsonencode(local.policy_definition_linux.policyRule)
  parameters  = jsonencode(local.policy_definition_linux.parameters)
}

# =============================================================================
# WINDOWS POLICY ASSIGNMENT - Assign at Resource Group level
# =============================================================================

resource "azurerm_resource_group_policy_assignment" "deploy_hello_folder_windows" {
  name                 = var.policy_assignment_name
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = azurerm_policy_definition.deploy_hello_folder_windows.id
  description          = "Assigns the policy to deploy a script that creates a hello folder on Windows VMs"
  display_name         = "Create hello folder on Windows VMs"

  location = azurerm_resource_group.main.location

  identity {
    type = "SystemAssigned"
  }

  non_compliance_message {
    content = "Windows VM does not have the hello folder creation script deployed."
  }

  depends_on = [
    azurerm_policy_definition.deploy_hello_folder_windows
  ]
}

# =============================================================================
# LINUX POLICY ASSIGNMENT - Assign at Resource Group level
# =============================================================================

resource "azurerm_resource_group_policy_assignment" "deploy_hello_folder_linux" {
  name                 = var.linux_policy_assignment_name
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = azurerm_policy_definition.deploy_hello_folder_linux.id
  description          = "Assigns the policy to deploy a script that creates a hello folder on Linux VMs"
  display_name         = "Create hello folder on Linux VMs"

  location = azurerm_resource_group.main.location

  identity {
    type = "SystemAssigned"
  }

  non_compliance_message {
    content = "Linux VM does not have the hello folder creation script deployed."
  }

  depends_on = [
    azurerm_policy_definition.deploy_hello_folder_linux
  ]
}

# =============================================================================
# ROLE ASSIGNMENTS - Grant VM Contributor to Policy's Managed Identities
# =============================================================================

resource "azurerm_role_assignment" "policy_vm_contributor_windows" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.deploy_hello_folder_windows.identity[0].principal_id

  depends_on = [
    azurerm_resource_group_policy_assignment.deploy_hello_folder_windows
  ]
}

resource "azurerm_role_assignment" "policy_vm_contributor_linux" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.deploy_hello_folder_linux.identity[0].principal_id

  depends_on = [
    azurerm_resource_group_policy_assignment.deploy_hello_folder_linux
  ]
}