resource kv_bicepdemo_8a145b 'Microsoft.KeyVault/vaults@2026-03-01-preview' = {
  location: 'swedencentral'
  name: 'kv-bicepdemo-8a145b'
  properties: {
    accessPolicies: []
    enableRbacAuthorization: true
    enableSoftDelete: true
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Disabled'
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: 'cd113f6c-ec9f-4e21-8fe4-84f3a0daed98'
    vaultUri: 'https://kv-bicepdemo-8a145b.vault.azure.net/'
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource id_bicepdemo_swec_01 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-05-31-preview' = {
  location: 'swedencentral'
  name: 'id-bicepdemo-swec-01'
  properties: {
    assignmentRestrictions: {
      providers: []
    }
    isolationScope: 'None'
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource nsg_bicepdemo_app_swec_01 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  location: 'swedencentral'
  name: 'nsg-bicepdemo-app-swec-01'
  properties: {
    securityRules: [
      {
        id: nsg_bicepdemo_app_swec_01_Allow_HTTPS_Inbound.id
        name: 'Allow-HTTPS-Inbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '443'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
      }
    ]
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource stbicepdemo8a145b 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  kind: 'StorageV2'
  location: 'swedencentral'
  name: 'stbicepdemo8a145b'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantDelegationSas: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: false
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Allow'
      ipRules: []
      ipv6Rules: []
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Disabled'
    supportsHttpsTrafficOnly: true
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource asp_bicepdemo_swec_01 'Microsoft.Web/serverfarms@2024-11-01' = {
  kind: 'linux'
  location: 'Sweden Central'
  name: 'asp-bicepdemo-swec-01'
  properties: {
    asyncScalingEnabled: false
    elasticScaleEnabled: false
    hyperV: false
    isSpot: false
    isXenon: false
    maximumElasticWorkerCount: 1
    perSiteScaling: false
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
  sku: {
    capacity: 1
    family: 'F'
    name: 'F1'
    size: 'F1'
    tier: 'Free'
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource nsg_bicepdemo_app_swec_01_Allow_HTTPS_Inbound 'Microsoft.Network/networkSecurityGroups/securityRules@2025-09-01' = {
  name: 'nsg-bicepdemo-app-swec-01/Allow-HTTPS-Inbound'
  properties: {
    access: 'Allow'
    destinationAddressPrefix: '*'
    destinationAddressPrefixes: []
    destinationPortRange: '443'
    destinationPortRanges: []
    direction: 'Inbound'
    priority: 100
    protocol: 'Tcp'
    sourceAddressPrefix: 'Internet'
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
  dependsOn: [
    nsg_bicepdemo_app_swec_01
  ]
}

resource vnet_bicepdemo_swec_01 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  location: 'swedencentral'
  name: 'vnet-bicepdemo-swec-01'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/16'
      ]
    }
    enableDdosProtection: false
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        id: vnet_bicepdemo_swec_01_snet_app.id
        name: 'snet-app'
        properties: {
          addressPrefix: '10.50.1.0/24'
          delegations: []
          networkSecurityGroup: {
            id: nsg_bicepdemo_app_swec_01.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        id: vnet_bicepdemo_swec_01_snet_data.id
        name: 'snet-data'
        properties: {
          addressPrefix: '10.50.2.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: [
            {
              locations: [
                'swedencentral'
                'swedensouth'
              ]
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
    ]
    virtualNetworkPeerings: []
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource vnet_bicepdemo_swec_01_snet_data 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: 'vnet-bicepdemo-swec-01/snet-data'
  properties: {
    addressPrefix: '10.50.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    serviceEndpoints: [
      {
        locations: [
          'swedencentral'
          'swedensouth'
        ]
        service: 'Microsoft.Storage'
      }
    ]
  }
  dependsOn: [
    vnet_bicepdemo_swec_01
  ]
}

resource stbicepdemo8a145b_default 'Microsoft.Storage/storageAccounts/blobServices@2026-06-01' = {
  parent: stbicepdemo8a145b
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
    staticWebsite: {
      enabled: false
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_stbicepdemo8a145b_default 'Microsoft.Storage/storageAccounts/fileServices@2026-06-01' = {
  parent: stbicepdemo8a145b
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    protocolSettings: {
      smb: {}
    }
    shareDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_stbicepdemo8a145b_default 'Microsoft.Storage/storageAccounts/queueServices@2026-06-01' = {
  parent: stbicepdemo8a145b
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_stbicepdemo8a145b_default 'Microsoft.Storage/storageAccounts/tableServices@2026-06-01' = {
  parent: stbicepdemo8a145b
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource app_bicepdemo_8a145b 'Microsoft.Web/sites@2024-11-01' = {
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/d351604a-5f79-488d-a73e-666707f38f1f/resourcegroups/rg-bicep-export-demo-swec-01/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-bicepdemo-swec-01': {}
    }
  }
  kind: 'app,linux'
  location: 'Sweden Central'
  name: 'app-bicepdemo-8a145b'
  properties: {
    clientAffinityEnabled: true
    clientAffinityProxyEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    containerSize: 0
    customDomainVerificationId: '823BEC2DBEDC7DD9B22C0603D754E0F28279735BF88404B7466FE9D51557808F'
    dailyMemoryTimeQuota: 0
    dnsConfiguration: {}
    enabled: true
    endToEndEncryptionEnabled: false
    hostNameSslStates: [
      {
        hostType: 'Standard'
        name: 'app-bicepdemo-8a145b.azurewebsites.net'
        sslState: 'Disabled'
      }
      {
        hostType: 'Repository'
        name: 'app-bicepdemo-8a145b.scm.azurewebsites.net'
        sslState: 'Disabled'
      }
    ]
    hostNamesDisabled: false
    httpsOnly: true
    hyperV: false
    ipMode: 'IPv4'
    isXenon: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    outboundVnetRouting: {
      allTraffic: false
      applicationTraffic: false
      backupRestoreTraffic: false
      contentShareTraffic: false
      imagePullTraffic: false
    }
    publicNetworkAccess: 'Enabled'
    redundancyMode: 'None'
    reserved: true
    scmSiteAlsoStopped: false
    serverFarmId: asp_bicepdemo_swec_01.id
    siteConfig: {
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      functionAppScaleLimit: 0
      http20Enabled: false
      linuxFxVersion: 'NODE|24-lts'
      minimumElasticInstanceCount: 1
      numberOfWorkers: 1
    }
    storageAccountRequired: false
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource app_bicepdemo_8a145b_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: app_bicepdemo_8a145b
  location: 'Sweden Central'
  name: 'ftp'
  properties: {
    allow: false
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource app_bicepdemo_8a145b_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: app_bicepdemo_8a145b
  location: 'Sweden Central'
  name: 'scm'
  properties: {
    allow: false
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource app_bicepdemo_8a145b_web 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: app_bicepdemo_8a145b
  location: 'Sweden Central'
  name: 'web'
  properties: {
    acrUseManagedIdentityCreds: false
    alwaysOn: false
    autoHealEnabled: false
    azureStorageAccounts: {}
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    detailedErrorLoggingEnabled: false
    elasticWebAppScaleLimit: 0
    experiments: {
      rampUpRules: []
    }
    ftpsState: 'FtpsOnly'
    functionsRuntimeScaleMonitoringEnabled: false
    http20Enabled: false
    http20ProxyFlag: 0
    httpLoggingEnabled: false
    ipSecurityRestrictions: [
      {
        action: 'Allow'
        description: 'Allow all access'
        ipAddress: 'Any'
        name: 'Allow all'
        priority: 2147483647
      }
    ]
    linuxFxVersion: 'NODE|24-lts'
    loadBalancing: 'LeastRequests'
    localMySqlEnabled: false
    logsDirectorySizeLimit: 35
    managedPipelineMode: 'Integrated'
    minTlsVersion: '1.2'
    minimumElasticInstanceCount: 1
    netFrameworkVersion: 'v4.0'
    numberOfWorkers: 1
    preWarmedInstanceCount: 0
    publicNetworkAccess: 'Enabled'
    publishingUsername: 'REDACTED'
    remoteDebuggingEnabled: false
    requestTracingEnabled: false
    scmIpSecurityRestrictions: [
      {
        action: 'Allow'
        description: 'Allow all access'
        ipAddress: 'Any'
        name: 'Allow all'
        priority: 2147483647
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    scmMinTlsVersion: '1.2'
    scmType: 'None'
    use32BitWorkerProcess: true
    virtualApplications: [
      {
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
        virtualPath: '/'
      }
    ]
    vnetPrivatePortsCount: 0
    vnetRouteAllEnabled: false
    webSocketsEnabled: false
    xManagedServiceIdentityId: 14966
  }
  tags: {
    environment: 'demo'
    managedBy: 'manual'
    purpose: 'bicep-export-demo'
  }
}

resource app_bicepdemo_8a145b_app_bicepdemo_8a145b_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-11-01' = {
  parent: app_bicepdemo_8a145b
  location: 'Sweden Central'
  name: 'app-bicepdemo-8a145b.azurewebsites.net'
  properties: {
    hostNameType: 'Verified'
    siteName: 'app-bicepdemo-8a145b'
  }
}

resource vnet_bicepdemo_swec_01_snet_app 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: 'vnet-bicepdemo-swec-01/snet-app'
  properties: {
    addressPrefix: '10.50.1.0/24'
    delegations: []
    networkSecurityGroup: {
      id: nsg_bicepdemo_app_swec_01.id
    }
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet_bicepdemo_swec_01
  ]
}

resource stbicepdemo8a145b_default_data 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-06-01' = {
  parent: stbicepdemo8a145b_default
  name: 'data'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    immutableStorageWithVersioning: {
      enabled: false
    }
    publicAccess: 'None'
  }
  dependsOn: [
    stbicepdemo8a145b
  ]
}
