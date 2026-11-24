// Reference result of the refactoring step: a clean, parameterized description of the resources
// deployed manually by deploy-demo-resources.ps1. Compare with export/<rg>/main.bicep (raw decompile).

targetScope = 'resourceGroup'

@description('Location of all resources.')
param location string = resourceGroup().location

@description('Unique suffix used in globally unique resource names.')
@maxLength(6)
param suffix string

@description('Tags applied to all resources.')
param tags object = {
  environment: 'demo'
  purpose: 'bicep-export-demo'
  managedBy: 'bicep'
}

@description('Name of an existing role assignment to adopt. Leave empty to generate a deterministic name.')
param storageRoleAssignmentName string = ''

@description('Name of an existing role assignment to adopt. Leave empty to generate a deterministic name.')
param keyVaultRoleAssignmentName string = ''

var roleIds = {
  storageBlobDataReader: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  keyVaultSecretsUser: '4633458b-17de-408a-b874-0445c86b69e6'
}

// ---------- Monitoring ----------
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'log-bicepdemo-swec-01'
  location: location
  tags: tags
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30
  }
}

// ---------- Storage ----------
resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'stbicepdemo${suffix}'
  location: location
  tags: tags
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
  }

  resource blobService 'blobServices' existing = {
    name: 'default'

    resource dataContainer 'containers' = {
      name: 'data'
      properties: { publicAccess: 'None' }
    }
  }
}

// ---------- Network ----------
resource nsgApp 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-bicepdemo-app-swec-01'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTPS-Inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
    ]
  }
}

// Subnets declared inline to avoid the VNet <-> subnet cycle produced by the raw decompile
resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-bicepdemo-swec-01'
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: ['10.50.0.0/16'] }
    subnets: [
      {
        name: 'snet-app'
        properties: {
          addressPrefix: '10.50.1.0/24'
          networkSecurityGroup: { id: nsgApp.id }
        }
      }
      {
        name: 'snet-data'
        properties: {
          addressPrefix: '10.50.2.0/24'
          serviceEndpoints: [{ service: 'Microsoft.Storage', locations: [location, 'swedensouth'] }]
        }
      }
    ]
  }
}

// ---------- Identity & secrets ----------
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-bicepdemo-swec-01'
  location: location
  tags: tags
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-bicepdemo-${suffix}'
  location: location
  tags: tags
  properties: {
    tenantId: tenant().tenantId
    sku: { family: 'A', name: 'standard' }
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    publicNetworkAccess: 'Disabled'
  }
}

// ---------- Web app ----------
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'asp-bicepdemo-swec-01'
  location: location
  tags: tags
  kind: 'linux'
  sku: { name: 'F1', tier: 'Free' }
  properties: { reserved: true }
}

resource webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: 'app-bicepdemo-${suffix}'
  location: location
  tags: tags
  kind: 'app,linux'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${identity.id}': {} }
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|24-lts'
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
      alwaysOn: false
      appSettings: [
        { name: 'STORAGE_ACCOUNT_NAME', value: storage.name }
        { name: 'KEY_VAULT_URI', value: keyVault.properties.vaultUri }
      ]
    }
  }
}

// ---------- Extension resources (not captured by the export) ----------
resource storageBlobReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: empty(storageRoleAssignmentName)
    ? guid(storage.id, identity.id, roleIds.storageBlobDataReader)
    : storageRoleAssignmentName
  scope: storage
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIds.storageBlobDataReader)
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource keyVaultSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: empty(keyVaultRoleAssignmentName)
    ? guid(keyVault.id, identity.id, roleIds.keyVaultSecretsUser)
    : keyVaultRoleAssignmentName
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIds.keyVaultSecretsUser)
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource keyVaultDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-to-law'
  scope: keyVault
  properties: {
    workspaceId: logAnalytics.id
    logs: [{ categoryGroup: 'audit', enabled: true }]
  }
}

resource blobDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-to-law'
  scope: storage::blobService
  properties: {
    workspaceId: logAnalytics.id
    logs: [
      { category: 'StorageWrite', enabled: true }
      { category: 'StorageDelete', enabled: true }
    ]
  }
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
