using 'main.bicep'

// Current settings for rg-bicep-export-demo-swec-01. Update the environment-specific
// values before deploying to another resource group or environment.
param location = 'swedencentral'
param suffix = '8a145b'
param namePrefix = 'bicepdemo'
param regionCode = 'swec-01'
param tags = {
  environment: 'demo'
  purpose: 'bicep-export-demo'
  managedBy: 'bicep'
}

// Adopt the role assignments created manually (names from bicep-generated-by-script/<rg>/role-assignments.json)
// instead of creating duplicates, which would fail with RoleAssignmentExists.
param storageRoleAssignmentName = '5c59702d-e454-4525-976d-5c87b3cfd5fa'
param keyVaultRoleAssignmentName = 'fd86603c-7819-4cf1-a801-0b41863cc237'

param enableTelemetry = true
param storageSkuName = 'Standard_LRS'
param storageAccessTier = 'Hot'
param keyVaultSku = 'standard'
param virtualNetworkAddressPrefix = '10.50.0.0/16'
param appSubnetAddressPrefix = '10.50.1.0/24'
param dataSubnetAddressPrefix = '10.50.2.0/24'
param appServicePlanSkuName = 'F1'
param appServicePlanSkuCapacity = 1
param linuxFxVersion = 'NODE|24-lts'
