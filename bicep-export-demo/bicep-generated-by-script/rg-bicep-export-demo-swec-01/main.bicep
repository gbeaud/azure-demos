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

resource log_bicepdemo_swec_01 'Microsoft.OperationalInsights/workspaces@2026-03-01' = {
  location: 'swedencentral'
  name: 'log-bicepdemo-swec-01'
  properties: {
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
      legacy: 0
      searchVersion: 1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: json('-1')
    }
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

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_General_AlphabeticallySortedComputers 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_General|AlphabeticallySortedComputers'
  properties: {
    category: 'General Exploration'
    displayName: 'All Computers with their most recent data'
    query: 'search not(ObjectName == "Advisor Metrics" or ObjectName == "ManagedSpace") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName="Advisor Metrics" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_General_dataPointsPerManagementGroup 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_General|dataPointsPerManagementGroup'
  properties: {
    category: 'General Exploration'
    displayName: 'Which Management Group is generating the most data points?'
    query: 'search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_General_dataTypeDistribution 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_General|dataTypeDistribution'
  properties: {
    category: 'General Exploration'
    displayName: 'Distribution of data Types'
    query: 'search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_General_StaleComputers 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_General|StaleComputers'
  properties: {
    category: 'General Exploration'
    displayName: 'Stale Computers (data older than 24 hours)'
    query: 'search not(ObjectName == "Advisor Metrics" or ObjectName == "ManagedSpace") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName="Advisor Metrics" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_AllEvents 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|AllEvents'
  properties: {
    category: 'Log Management'
    displayName: 'All Events'
    query: 'Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_AllSyslog 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|AllSyslog'
  properties: {
    category: 'Log Management'
    displayName: 'All Syslogs'
    query: 'Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_AllSyslogByFacility 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|AllSyslogByFacility'
  properties: {
    category: 'Log Management'
    displayName: 'All Syslog Records grouped by Facility'
    query: 'Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_AllSyslogByProcess 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|AllSyslogByProcessName'
  properties: {
    category: 'Log Management'
    displayName: 'All Syslog Records grouped by ProcessName'
    query: 'Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_AllSyslogsWithErrors 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|AllSyslogsWithErrors'
  properties: {
    category: 'Log Management'
    displayName: 'All Syslog Records with Errors'
    query: 'Syslog | where SeverityLevel == "error" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_AverageHTTPRequestTimeByClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|AverageHTTPRequestTimeByClientIPAddress'
  properties: {
    category: 'Log Management'
    displayName: 'Average HTTP Request time by Client IP Address'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_AverageHTTPRequestTimeHTTPMethod 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|AverageHTTPRequestTimeHTTPMethod'
  properties: {
    category: 'Log Management'
    displayName: 'Average HTTP Request time by HTTP Method'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_CountIISLogEntriesClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|CountIISLogEntriesClientIPAddress'
  properties: {
    category: 'Log Management'
    displayName: 'Count of IIS Log Entries by Client IP Address'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_CountIISLogEntriesHTTPRequestMethod 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|CountIISLogEntriesHTTPRequestMethod'
  properties: {
    category: 'Log Management'
    displayName: 'Count of IIS Log Entries by HTTP Request Method'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_CountIISLogEntriesHTTPUserAgent 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|CountIISLogEntriesHTTPUserAgent'
  properties: {
    category: 'Log Management'
    displayName: 'Count of IIS Log Entries by HTTP User Agent'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_CountOfIISLogEntriesByHostRequestedByClient 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient'
  properties: {
    category: 'Log Management'
    displayName: 'Count of IIS Log Entries by Host requested by client'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_CountOfIISLogEntriesByURLForHost 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|CountOfIISLogEntriesByURLForHost'
  properties: {
    category: 'Log Management'
    displayName: 'Count of IIS Log Entries by URL for the host "www.contoso.com" (replace with your own)'
    query: 'search csHost == "www.contoso.com" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost="www.contoso.com" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_CountOfIISLogEntriesByURLRequestedByClient 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient'
  properties: {
    category: 'Log Management'
    displayName: 'Count of IIS Log Entries by URL requested by client (without query strings)'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_CountOfWarningEvents 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|CountOfWarningEvents'
  properties: {
    category: 'Log Management'
    displayName: 'Count of Events with level "Warning" grouped by Event ID'
    query: 'Event | where EventLevelName == "warning" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_DisplayBreakdownRespondCodes 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|DisplayBreakdownRespondCodes'
  properties: {
    category: 'Log Management'
    displayName: 'Shows breakdown of response codes'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_EventsByEventLog 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|EventsByEventLog'
  properties: {
    category: 'Log Management'
    displayName: 'Count of Events grouped by Event Log'
    query: 'Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_EventsByEventsID 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|EventsByEventsID'
  properties: {
    category: 'Log Management'
    displayName: 'Count of Events grouped by Event ID'
    query: 'Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_EventsByEventSource 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|EventsByEventSource'
  properties: {
    category: 'Log Management'
    displayName: 'Count of Events grouped by Event Source'
    query: 'Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_EventsInOMBetween2000to3000 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|EventsInOMBetween2000to3000'
  properties: {
    category: 'Log Management'
    displayName: 'Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000'
    query: 'Event | where EventLog == "Operations Manager" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog="Operations Manager" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_EventsWithStartedinEventID 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|EventsWithStartedinEventID'
  properties: {
    category: 'Log Management'
    displayName: 'Count of Events containing the word "started" grouped by EventID'
    query: 'search in (Event) "started" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event "started" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_FindMaximumTimeTakenForEachPage 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|FindMaximumTimeTakenForEachPage'
  properties: {
    category: 'Log Management'
    displayName: 'Find the maximum time taken for each page'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_IISLogEntriesForClientIP 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|IISLogEntriesForClientIP'
  properties: {
    category: 'Log Management'
    displayName: 'IIS Log Entries for a specific client IP Address (replace with your own)'
    query: 'search cIP == "192.168.0.1" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP="192.168.0.1" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_ListAllIISLogEntries 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|ListAllIISLogEntries'
  properties: {
    category: 'Log Management'
    displayName: 'All IIS Log Entries'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_NoOfConnectionsToOMSDKService 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|NoOfConnectionsToOMSDKService'
  properties: {
    category: 'Log Management'
    displayName: 'How many connections to Operations Manager\'s SDK service by day'
    query: 'Event | where EventID == 26328 and EventLog == "Operations Manager" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog="Operations Manager" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_ServerRestartTime 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|ServerRestartTime'
  properties: {
    category: 'Log Management'
    displayName: 'When did my servers initiate restart?'
    query: 'search in (Event) "shutdown" and EventLog == "System" and Source == "User32" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_Show404PagesList 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|Show404PagesList'
  properties: {
    category: 'Log Management'
    displayName: 'Shows which pages people are getting a 404 for'
    query: 'search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_ShowServersThrowingInternalServerError 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|ShowServersThrowingInternalServerError'
  properties: {
    category: 'Log Management'
    displayName: 'Shows servers that are throwing internal server error'
    query: 'search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_TotalBytesReceivedByEachAzureRoleInstance 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance'
  properties: {
    category: 'Log Management'
    displayName: 'Total Bytes received by each Azure Role Instance'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_TotalBytesReceivedByEachIISComputer 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|TotalBytesReceivedByEachIISComputer'
  properties: {
    category: 'Log Management'
    displayName: 'Total Bytes received by each IIS Computer'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_TotalBytesRespondedToClientsByClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress'
  properties: {
    category: 'Log Management'
    displayName: 'Total Bytes responded back to clients by Client IP Address'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_TotalBytesRespondedToClientsByEachIISServerIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress'
  properties: {
    category: 'Log Management'
    displayName: 'Total Bytes responded back to clients by each IIS ServerIP Address'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_TotalBytesSentByClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|TotalBytesSentByClientIPAddress'
  properties: {
    category: 'Log Management'
    displayName: 'Total Bytes sent by Client IP Address'
    query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_WarningEvents 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|WarningEvents'
  properties: {
    category: 'Log Management'
    displayName: 'All Events with level "Warning"'
    query: 'Event | where EventLevelName == "warning" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_WindowsFireawallPolicySettingsChanged 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|WindowsFireawallPolicySettingsChanged'
  properties: {
    category: 'Log Management'
    displayName: 'Windows Firewall Policy settings have changed'
    query: 'Event | where EventLog == "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog="Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_LogManagement_log_bicepdemo_swec_01_LogManagement_WindowsFireawallPolicySettingsChangedByMachines 'Microsoft.OperationalInsights/workspaces/savedSearches@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogManagement(log-bicepdemo-swec-01)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines'
  properties: {
    category: 'Log Management'
    displayName: 'On which machines and how many times have Windows Firewall Policy settings changed'
    query: 'Event | where EventLog == "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog="Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
    version: 2
  }
}

resource log_bicepdemo_swec_01_AACAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AACAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AACAudit'
      name: 'AACAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AACHttpRequest 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AACHttpRequest'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AACHttpRequest'
      name: 'AACHttpRequest'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADAgentRiskEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADAgentRiskEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADAgentRiskEvents'
      name: 'AADAgentRiskEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADB2CRequestLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADB2CRequestLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADB2CRequestLogs'
      name: 'AADB2CRequestLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADCustomSecurityAttributeAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADCustomSecurityAttributeAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADCustomSecurityAttributeAuditLogs'
      name: 'AADCustomSecurityAttributeAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesAccountLogon 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesAccountLogon'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesAccountLogon'
      name: 'AADDomainServicesAccountLogon'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesAccountManagement 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesAccountManagement'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesAccountManagement'
      name: 'AADDomainServicesAccountManagement'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesDirectoryServiceAccess 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesDirectoryServiceAccess'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesDirectoryServiceAccess'
      name: 'AADDomainServicesDirectoryServiceAccess'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesDNSAuditsDynamicUpdates 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesDNSAuditsDynamicUpdates'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesDNSAuditsDynamicUpdates'
      name: 'AADDomainServicesDNSAuditsDynamicUpdates'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesDNSAuditsGeneral 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesDNSAuditsGeneral'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesDNSAuditsGeneral'
      name: 'AADDomainServicesDNSAuditsGeneral'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesLogonLogoff 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesLogonLogoff'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesLogonLogoff'
      name: 'AADDomainServicesLogonLogoff'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesPolicyChange 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesPolicyChange'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesPolicyChange'
      name: 'AADDomainServicesPolicyChange'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesPrivilegeUse 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesPrivilegeUse'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesPrivilegeUse'
      name: 'AADDomainServicesPrivilegeUse'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADDomainServicesSystemSecurity 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADDomainServicesSystemSecurity'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADDomainServicesSystemSecurity'
      name: 'AADDomainServicesSystemSecurity'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADFirstPartyToFirstPartySignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADFirstPartyToFirstPartySignInLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADFirstPartyToFirstPartySignInLogs'
      name: 'AADFirstPartyToFirstPartySignInLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADGraphActivityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADGraphActivityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADGraphActivityLogs'
      name: 'AADGraphActivityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADManagedIdentitySignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADManagedIdentitySignInLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADManagedIdentitySignInLogs'
      name: 'AADManagedIdentitySignInLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADNonInteractiveUserSignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADNonInteractiveUserSignInLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADNonInteractiveUserSignInLogs'
      name: 'AADNonInteractiveUserSignInLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADProvisioningLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADProvisioningLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADProvisioningLogs'
      name: 'AADProvisioningLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADRiskyAgents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADRiskyAgents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADRiskyAgents'
      name: 'AADRiskyAgents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADRiskyServicePrincipals 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADRiskyServicePrincipals'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADRiskyServicePrincipals'
      name: 'AADRiskyServicePrincipals'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADRiskyUsers 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADRiskyUsers'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADRiskyUsers'
      name: 'AADRiskyUsers'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADServicePrincipalRiskEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADServicePrincipalRiskEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADServicePrincipalRiskEvents'
      name: 'AADServicePrincipalRiskEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADServicePrincipalSignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADServicePrincipalSignInLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADServicePrincipalSignInLogs'
      name: 'AADServicePrincipalSignInLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AADUserRiskEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AADUserRiskEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AADUserRiskEvents'
      name: 'AADUserRiskEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ABSBotRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ABSBotRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ABSBotRequests'
      name: 'ABSBotRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACICollaborationAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACICollaborationAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACICollaborationAudit'
      name: 'ACICollaborationAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACLTransactionLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACLTransactionLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACLTransactionLogs'
      name: 'ACLTransactionLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACLUserDefinedLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACLUserDefinedLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACLUserDefinedLogs'
      name: 'ACLUserDefinedLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACRConnectedClientList 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACRConnectedClientList'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACRConnectedClientList'
      name: 'ACRConnectedClientList'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACREntraAuthenticationAuditLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACREntraAuthenticationAuditLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACREntraAuthenticationAuditLog'
      name: 'ACREntraAuthenticationAuditLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSAdvancedMessagingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSAdvancedMessagingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSAdvancedMessagingOperations'
      name: 'ACSAdvancedMessagingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSAuthIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSAuthIncomingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSAuthIncomingOperations'
      name: 'ACSAuthIncomingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSBillingUsage 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSBillingUsage'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSBillingUsage'
      name: 'ACSBillingUsage'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallAutomationIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallAutomationIncomingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallAutomationIncomingOperations'
      name: 'ACSCallAutomationIncomingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallAutomationMediaSummary 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallAutomationMediaSummary'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallAutomationMediaSummary'
      name: 'ACSCallAutomationMediaSummary'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallAutomationStreamingUsage 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallAutomationStreamingUsage'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallAutomationStreamingUsage'
      name: 'ACSCallAutomationStreamingUsage'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallClientMediaStatsTimeSeries 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallClientMediaStatsTimeSeries'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallClientMediaStatsTimeSeries'
      name: 'ACSCallClientMediaStatsTimeSeries'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallClientOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallClientOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallClientOperations'
      name: 'ACSCallClientOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallClientServiceRequestAndOutcome 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallClientServiceRequestAndOutcome'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallClientServiceRequestAndOutcome'
      name: 'ACSCallClientServiceRequestAndOutcome'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallClosedCaptionsSummary 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallClosedCaptionsSummary'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallClosedCaptionsSummary'
      name: 'ACSCallClosedCaptionsSummary'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallDiagnostics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallDiagnostics'
      name: 'ACSCallDiagnostics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallDiagnosticsUpdates 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallDiagnosticsUpdates'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallDiagnosticsUpdates'
      name: 'ACSCallDiagnosticsUpdates'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallingMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallingMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallingMetrics'
      name: 'ACSCallingMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallRecordingIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallRecordingIncomingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallRecordingIncomingOperations'
      name: 'ACSCallRecordingIncomingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallRecordingSummary 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallRecordingSummary'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallRecordingSummary'
      name: 'ACSCallRecordingSummary'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallSummary 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallSummary'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallSummary'
      name: 'ACSCallSummary'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallSummaryUpdates 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallSummaryUpdates'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallSummaryUpdates'
      name: 'ACSCallSummaryUpdates'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSCallSurvey 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSCallSurvey'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSCallSurvey'
      name: 'ACSCallSurvey'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSChatIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSChatIncomingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSChatIncomingOperations'
      name: 'ACSChatIncomingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSEmailSendMailOperational 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSEmailSendMailOperational'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSEmailSendMailOperational'
      name: 'ACSEmailSendMailOperational'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSEmailStatusUpdateOperational 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSEmailStatusUpdateOperational'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSEmailStatusUpdateOperational'
      name: 'ACSEmailStatusUpdateOperational'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSEmailUserEngagementOperational 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSEmailUserEngagementOperational'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSEmailUserEngagementOperational'
      name: 'ACSEmailUserEngagementOperational'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSJobRouterIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSJobRouterIncomingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSJobRouterIncomingOperations'
      name: 'ACSJobRouterIncomingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSOptOutManagementOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSOptOutManagementOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSOptOutManagementOperations'
      name: 'ACSOptOutManagementOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSRoomsIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSRoomsIncomingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSRoomsIncomingOperations'
      name: 'ACSRoomsIncomingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ACSSMSIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ACSSMSIncomingOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ACSSMSIncomingOperations'
      name: 'ACSSMSIncomingOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADAssessmentRecommendation'
      name: 'ADAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AddonAzureBackupAlerts 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AddonAzureBackupAlerts'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AddonAzureBackupAlerts'
      name: 'AddonAzureBackupAlerts'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AddonAzureBackupJobs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AddonAzureBackupJobs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AddonAzureBackupJobs'
      name: 'AddonAzureBackupJobs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AddonAzureBackupPolicy 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AddonAzureBackupPolicy'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AddonAzureBackupPolicy'
      name: 'AddonAzureBackupPolicy'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AddonAzureBackupProtectedInstance 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AddonAzureBackupProtectedInstance'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AddonAzureBackupProtectedInstance'
      name: 'AddonAzureBackupProtectedInstance'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AddonAzureBackupStorage 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AddonAzureBackupStorage'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AddonAzureBackupStorage'
      name: 'AddonAzureBackupStorage'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFActivityRun 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFActivityRun'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFActivityRun'
      name: 'ADFActivityRun'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFAirflowSchedulerLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFAirflowSchedulerLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFAirflowSchedulerLogs'
      name: 'ADFAirflowSchedulerLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFAirflowTaskLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFAirflowTaskLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFAirflowTaskLogs'
      name: 'ADFAirflowTaskLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFAirflowWebLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFAirflowWebLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFAirflowWebLogs'
      name: 'ADFAirflowWebLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFAirflowWorkerLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFAirflowWorkerLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFAirflowWorkerLogs'
      name: 'ADFAirflowWorkerLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFPipelineRun 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFPipelineRun'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFPipelineRun'
      name: 'ADFPipelineRun'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSandboxActivityRun 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSandboxActivityRun'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSandboxActivityRun'
      name: 'ADFSandboxActivityRun'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSandboxPipelineRun 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSandboxPipelineRun'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSandboxPipelineRun'
      name: 'ADFSandboxPipelineRun'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSSignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSSignInLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSSignInLogs'
      name: 'ADFSSignInLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSSISIntegrationRuntimeLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSSISIntegrationRuntimeLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSSISIntegrationRuntimeLogs'
      name: 'ADFSSISIntegrationRuntimeLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSSISPackageEventMessageContext 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSSISPackageEventMessageContext'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSSISPackageEventMessageContext'
      name: 'ADFSSISPackageEventMessageContext'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSSISPackageEventMessages 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSSISPackageEventMessages'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSSISPackageEventMessages'
      name: 'ADFSSISPackageEventMessages'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSSISPackageExecutableStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSSISPackageExecutableStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSSISPackageExecutableStatistics'
      name: 'ADFSSISPackageExecutableStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSSISPackageExecutionComponentPhases 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSSISPackageExecutionComponentPhases'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSSISPackageExecutionComponentPhases'
      name: 'ADFSSISPackageExecutionComponentPhases'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFSSISPackageExecutionDataStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFSSISPackageExecutionDataStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFSSISPackageExecutionDataStatistics'
      name: 'ADFSSISPackageExecutionDataStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADFTriggerRun 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADFTriggerRun'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADFTriggerRun'
      name: 'ADFTriggerRun'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADGSyslogEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADGSyslogEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADGSyslogEvent'
      name: 'ADGSyslogEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADReplicationResult 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADReplicationResult'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADReplicationResult'
      name: 'ADReplicationResult'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADSecurityAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADSecurityAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADSecurityAssessmentRecommendation'
      name: 'ADSecurityAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADTDataHistoryOperation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADTDataHistoryOperation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADTDataHistoryOperation'
      name: 'ADTDataHistoryOperation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADTDigitalTwinsOperation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADTDigitalTwinsOperation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADTDigitalTwinsOperation'
      name: 'ADTDigitalTwinsOperation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADTEventRoutesOperation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADTEventRoutesOperation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADTEventRoutesOperation'
      name: 'ADTEventRoutesOperation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADTModelsOperation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADTModelsOperation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADTModelsOperation'
      name: 'ADTModelsOperation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADTQueryOperation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADTQueryOperation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADTQueryOperation'
      name: 'ADTQueryOperation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADXCommand 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADXCommand'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADXCommand'
      name: 'ADXCommand'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADXDataOperation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADXDataOperation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADXDataOperation'
      name: 'ADXDataOperation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADXIngestionBatching 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADXIngestionBatching'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADXIngestionBatching'
      name: 'ADXIngestionBatching'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADXJournal 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADXJournal'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADXJournal'
      name: 'ADXJournal'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADXQuery 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADXQuery'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADXQuery'
      name: 'ADXQuery'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADXTableDetails 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADXTableDetails'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADXTableDetails'
      name: 'ADXTableDetails'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ADXTableUsageStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ADXTableUsageStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ADXTableUsageStatistics'
      name: 'ADXTableUsageStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AegDataPlaneRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AegDataPlaneRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AegDataPlaneRequests'
      name: 'AegDataPlaneRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AegDeliveryFailureLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AegDeliveryFailureLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AegDeliveryFailureLogs'
      name: 'AegDeliveryFailureLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AegPublishFailureLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AegPublishFailureLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AegPublishFailureLogs'
      name: 'AegPublishFailureLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AEWAssignmentBlobLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AEWAssignmentBlobLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AEWAssignmentBlobLogs'
      name: 'AEWAssignmentBlobLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AEWAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AEWAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AEWAuditLogs'
      name: 'AEWAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AEWComputePipelinesLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AEWComputePipelinesLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AEWComputePipelinesLogs'
      name: 'AEWComputePipelinesLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AEWExperimentAssignmentSummary 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AEWExperimentAssignmentSummary'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AEWExperimentAssignmentSummary'
      name: 'AEWExperimentAssignmentSummary'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AEWExperimentScorecardMetricPairs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AEWExperimentScorecardMetricPairs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AEWExperimentScorecardMetricPairs'
      name: 'AEWExperimentScorecardMetricPairs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AEWExperimentScorecards 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AEWExperimentScorecards'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AEWExperimentScorecards'
      name: 'AEWExperimentScorecards'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AFSAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AFSAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AFSAuditLogs'
      name: 'AFSAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGCAccessLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGCAccessLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGCAccessLogs'
      name: 'AGCAccessLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGCFirewallLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGCFirewallLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGCFirewallLogs'
      name: 'AGCFirewallLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgentFabricFlowLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgentFabricFlowLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgentFabricFlowLogs'
      name: 'AgentFabricFlowLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodApplicationAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodApplicationAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodApplicationAuditLogs'
      name: 'AgriFoodApplicationAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodFarmManagementLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodFarmManagementLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodFarmManagementLogs'
      name: 'AgriFoodFarmManagementLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodFarmOperationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodFarmOperationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodFarmOperationLogs'
      name: 'AgriFoodFarmOperationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodInsightLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodInsightLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodInsightLogs'
      name: 'AgriFoodInsightLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodJobProcessedLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodJobProcessedLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodJobProcessedLogs'
      name: 'AgriFoodJobProcessedLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodModelInferenceLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodModelInferenceLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodModelInferenceLogs'
      name: 'AgriFoodModelInferenceLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodProviderAuthLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodProviderAuthLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodProviderAuthLogs'
      name: 'AgriFoodProviderAuthLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodSatelliteLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodSatelliteLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodSatelliteLogs'
      name: 'AgriFoodSatelliteLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodSensorManagementLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodSensorManagementLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodSensorManagementLogs'
      name: 'AgriFoodSensorManagementLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AgriFoodWeatherLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AgriFoodWeatherLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AgriFoodWeatherLogs'
      name: 'AgriFoodWeatherLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGSGrafanaAlertAuthFailure 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGSGrafanaAlertAuthFailure'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGSGrafanaAlertAuthFailure'
      name: 'AGSGrafanaAlertAuthFailure'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGSGrafanaLoginEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGSGrafanaLoginEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGSGrafanaLoginEvents'
      name: 'AGSGrafanaLoginEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGSGrafanaUsageInsightsEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGSGrafanaUsageInsightsEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGSGrafanaUsageInsightsEvents'
      name: 'AGSGrafanaUsageInsightsEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGSUpdateEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGSUpdateEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGSUpdateEvents'
      name: 'AGSUpdateEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGWAccessLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGWAccessLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGWAccessLogs'
      name: 'AGWAccessLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGWFirewallLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGWFirewallLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGWFirewallLogs'
      name: 'AGWFirewallLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AGWPerformanceLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AGWPerformanceLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AGWPerformanceLogs'
      name: 'AGWPerformanceLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AHCIDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AHCIDiagnosticLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AHCIDiagnosticLogs'
      name: 'AHCIDiagnosticLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AHDSDeidAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AHDSDeidAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AHDSDeidAuditLogs'
      name: 'AHDSDeidAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AHDSDicomAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AHDSDicomAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AHDSDicomAuditLogs'
      name: 'AHDSDicomAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AHDSDicomDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AHDSDicomDiagnosticLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AHDSDicomDiagnosticLogs'
      name: 'AHDSDicomDiagnosticLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AHDSMedTechDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AHDSMedTechDiagnosticLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AHDSMedTechDiagnosticLogs'
      name: 'AHDSMedTechDiagnosticLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AirflowDagProcessingLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AirflowDagProcessingLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AirflowDagProcessingLogs'
      name: 'AirflowDagProcessingLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AKSAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AKSAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AKSAudit'
      name: 'AKSAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AKSAuditAdmin 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AKSAuditAdmin'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AKSAuditAdmin'
      name: 'AKSAuditAdmin'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AKSControlPlane 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AKSControlPlane'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AKSControlPlane'
      name: 'AKSControlPlane'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ALBHealthEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ALBHealthEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ALBHealthEvent'
      name: 'ALBHealthEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Alert 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Alert'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Alert'
      name: 'Alert'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AMAHealth 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AMAHealth'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AMAHealth'
      name: 'AMAHealth'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlComputeClusterEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlComputeClusterEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlComputeClusterEvent'
      name: 'AmlComputeClusterEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlComputeClusterNodeEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlComputeClusterNodeEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlComputeClusterNodeEvent'
      name: 'AmlComputeClusterNodeEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlComputeCpuGpuUtilization 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlComputeCpuGpuUtilization'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlComputeCpuGpuUtilization'
      name: 'AmlComputeCpuGpuUtilization'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlComputeInstanceEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlComputeInstanceEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlComputeInstanceEvent'
      name: 'AmlComputeInstanceEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlComputeJobEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlComputeJobEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlComputeJobEvent'
      name: 'AmlComputeJobEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlDataLabelEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlDataLabelEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlDataLabelEvent'
      name: 'AmlDataLabelEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlDataSetEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlDataSetEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlDataSetEvent'
      name: 'AmlDataSetEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlDataStoreEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlDataStoreEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlDataStoreEvent'
      name: 'AmlDataStoreEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlDeploymentEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlDeploymentEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlDeploymentEvent'
      name: 'AmlDeploymentEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlEnvironmentEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlEnvironmentEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlEnvironmentEvent'
      name: 'AmlEnvironmentEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlInferencingEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlInferencingEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlInferencingEvent'
      name: 'AmlInferencingEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AMLManagedNetworkEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AMLManagedNetworkEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AMLManagedNetworkEvent'
      name: 'AMLManagedNetworkEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlModelsEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlModelsEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlModelsEvent'
      name: 'AmlModelsEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlOnlineEndpointConsoleLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlOnlineEndpointConsoleLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlOnlineEndpointConsoleLog'
      name: 'AmlOnlineEndpointConsoleLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlOnlineEndpointEventLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlOnlineEndpointEventLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlOnlineEndpointEventLog'
      name: 'AmlOnlineEndpointEventLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlOnlineEndpointTrafficLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlOnlineEndpointTrafficLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlOnlineEndpointTrafficLog'
      name: 'AmlOnlineEndpointTrafficLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlPipelineEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlPipelineEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlPipelineEvent'
      name: 'AmlPipelineEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlRegistryReadEventsLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlRegistryReadEventsLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlRegistryReadEventsLog'
      name: 'AmlRegistryReadEventsLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlRegistryWriteEventsLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlRegistryWriteEventsLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlRegistryWriteEventsLog'
      name: 'AmlRegistryWriteEventsLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlRunEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlRunEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlRunEvent'
      name: 'AmlRunEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AmlRunStatusChangedEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AmlRunStatusChangedEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AmlRunStatusChangedEvent'
      name: 'AmlRunStatusChangedEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AMSKeyDeliveryRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AMSKeyDeliveryRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AMSKeyDeliveryRequests'
      name: 'AMSKeyDeliveryRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AMSLiveEventOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AMSLiveEventOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AMSLiveEventOperations'
      name: 'AMSLiveEventOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AMSMediaAccountHealth 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AMSMediaAccountHealth'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AMSMediaAccountHealth'
      name: 'AMSMediaAccountHealth'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AMSStreamingEndpointRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AMSStreamingEndpointRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AMSStreamingEndpointRequests'
      name: 'AMSStreamingEndpointRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AMWMetricsUsageDetails 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AMWMetricsUsageDetails'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AMWMetricsUsageDetails'
      name: 'AMWMetricsUsageDetails'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ANFFileAccess 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ANFFileAccess'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ANFFileAccess'
      name: 'ANFFileAccess'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ANFTopClientReadIOPS 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ANFTopClientReadIOPS'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ANFTopClientReadIOPS'
      name: 'ANFTopClientReadIOPS'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ANFTopClientWriteIOPS 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ANFTopClientWriteIOPS'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ANFTopClientWriteIOPS'
      name: 'ANFTopClientWriteIOPS'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ANFTopFileReadIOPS 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ANFTopFileReadIOPS'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ANFTopFileReadIOPS'
      name: 'ANFTopFileReadIOPS'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ANFTopFileWriteIOPS 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ANFTopFileWriteIOPS'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ANFTopFileWriteIOPS'
      name: 'ANFTopFileWriteIOPS'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AOIDatabaseQuery 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AOIDatabaseQuery'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AOIDatabaseQuery'
      name: 'AOIDatabaseQuery'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AOIDigestion 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AOIDigestion'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AOIDigestion'
      name: 'AOIDigestion'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AOIStorage 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AOIStorage'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AOIStorage'
      name: 'AOIStorage'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ApiManagementGatewayLlmLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ApiManagementGatewayLlmLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ApiManagementGatewayLlmLog'
      name: 'ApiManagementGatewayLlmLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ApiManagementGatewayLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ApiManagementGatewayLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ApiManagementGatewayLogs'
      name: 'ApiManagementGatewayLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ApiManagementGatewayMCPLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ApiManagementGatewayMCPLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ApiManagementGatewayMCPLog'
      name: 'ApiManagementGatewayMCPLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ApiManagementWebSocketConnectionLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ApiManagementWebSocketConnectionLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ApiManagementWebSocketConnectionLogs'
      name: 'ApiManagementWebSocketConnectionLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_APIMDevPortalAuditDiagnosticLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'APIMDevPortalAuditDiagnosticLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'APIMDevPortalAuditDiagnosticLog'
      name: 'APIMDevPortalAuditDiagnosticLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppAvailabilityResults 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppAvailabilityResults'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppAvailabilityResults'
      name: 'AppAvailabilityResults'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppBrowserTimings 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppBrowserTimings'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppBrowserTimings'
      name: 'AppBrowserTimings'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppCenterError 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppCenterError'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppCenterError'
      name: 'AppCenterError'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppDependencies 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppDependencies'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppDependencies'
      name: 'AppDependencies'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppEnvSessionConsoleLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppEnvSessionConsoleLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppEnvSessionConsoleLogs'
      name: 'AppEnvSessionConsoleLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppEnvSessionLifecycleLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppEnvSessionLifecycleLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppEnvSessionLifecycleLogs'
      name: 'AppEnvSessionLifecycleLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppEnvSessionPoolEventLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppEnvSessionPoolEventLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppEnvSessionPoolEventLogs'
      name: 'AppEnvSessionPoolEventLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppEnvSpringAppConsoleLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppEnvSpringAppConsoleLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppEnvSpringAppConsoleLogs'
      name: 'AppEnvSpringAppConsoleLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppEvents'
      name: 'AppEvents'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppExceptions 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppExceptions'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppExceptions'
      name: 'AppExceptions'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppGenAIContent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppGenAIContent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppGenAIContent'
      name: 'AppGenAIContent'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppMetrics'
      name: 'AppMetrics'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppPageViews 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppPageViews'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppPageViews'
      name: 'AppPageViews'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppPerformanceCounters 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppPerformanceCounters'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppPerformanceCounters'
      name: 'AppPerformanceCounters'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppPlatformBuildLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppPlatformBuildLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppPlatformBuildLogs'
      name: 'AppPlatformBuildLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppPlatformContainerEventLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppPlatformContainerEventLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppPlatformContainerEventLogs'
      name: 'AppPlatformContainerEventLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppPlatformIngressLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppPlatformIngressLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppPlatformIngressLogs'
      name: 'AppPlatformIngressLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppPlatformLogsforSpring 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppPlatformLogsforSpring'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppPlatformLogsforSpring'
      name: 'AppPlatformLogsforSpring'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppPlatformSystemLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppPlatformSystemLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppPlatformSystemLogs'
      name: 'AppPlatformSystemLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppRequests'
      name: 'AppRequests'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppServiceAntivirusScanAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceAntivirusScanAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceAntivirusScanAuditLogs'
      name: 'AppServiceAntivirusScanAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceAppLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceAppLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceAppLogs'
      name: 'AppServiceAppLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceAuditLogs'
      name: 'AppServiceAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceAuthenticationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceAuthenticationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceAuthenticationLogs'
      name: 'AppServiceAuthenticationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceConsoleLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceConsoleLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceConsoleLogs'
      name: 'AppServiceConsoleLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceEnvironmentPlatformLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceEnvironmentPlatformLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceEnvironmentPlatformLogs'
      name: 'AppServiceEnvironmentPlatformLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceFileAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceFileAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceFileAuditLogs'
      name: 'AppServiceFileAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceHTTPLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceHTTPLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceHTTPLogs'
      name: 'AppServiceHTTPLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceIPSecAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceIPSecAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceIPSecAuditLogs'
      name: 'AppServiceIPSecAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServicePlatformLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServicePlatformLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServicePlatformLogs'
      name: 'AppServicePlatformLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppServiceServerlessSecurityPluginData 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppServiceServerlessSecurityPluginData'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AppServiceServerlessSecurityPluginData'
      name: 'AppServiceServerlessSecurityPluginData'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AppSystemEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppSystemEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppSystemEvents'
      name: 'AppSystemEvents'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AppTraces 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AppTraces'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AppTraces'
      name: 'AppTraces'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_ArcK8sAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ArcK8sAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ArcK8sAudit'
      name: 'ArcK8sAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ArcK8sAuditAdmin 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ArcK8sAuditAdmin'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ArcK8sAuditAdmin'
      name: 'ArcK8sAuditAdmin'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ArcK8sControlPlane 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ArcK8sControlPlane'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ArcK8sControlPlane'
      name: 'ArcK8sControlPlane'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASCAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASCAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASCAuditLogs'
      name: 'ASCAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASCDeviceEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASCDeviceEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASCDeviceEvents'
      name: 'ASCDeviceEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRJobs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRJobs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRJobs'
      name: 'ASRJobs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRReplicatedItems 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRReplicatedItems'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRReplicatedItems'
      name: 'ASRReplicatedItems'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRv2HealthEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRv2HealthEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRv2HealthEvents'
      name: 'ASRv2HealthEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRv2JobEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRv2JobEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRv2JobEvents'
      name: 'ASRv2JobEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRv2ProtectedItems 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRv2ProtectedItems'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRv2ProtectedItems'
      name: 'ASRv2ProtectedItems'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRv2ReplicationExtensions 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRv2ReplicationExtensions'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRv2ReplicationExtensions'
      name: 'ASRv2ReplicationExtensions'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRv2ReplicationPolicies 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRv2ReplicationPolicies'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRv2ReplicationPolicies'
      name: 'ASRv2ReplicationPolicies'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ASRv2ReplicationVaults 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ASRv2ReplicationVaults'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ASRv2ReplicationVaults'
      name: 'ASRv2ReplicationVaults'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ATCExpressRouteCircuitIpfix 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ATCExpressRouteCircuitIpfix'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ATCExpressRouteCircuitIpfix'
      name: 'ATCExpressRouteCircuitIpfix'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ATCMicrosoftPeeringMetadata 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ATCMicrosoftPeeringMetadata'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ATCMicrosoftPeeringMetadata'
      name: 'ATCMicrosoftPeeringMetadata'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ATCPrivatePeeringMetadata 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ATCPrivatePeeringMetadata'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ATCPrivatePeeringMetadata'
      name: 'ATCPrivatePeeringMetadata'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AuditLogs'
      name: 'AuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AutoscaleEvaluationsLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AutoscaleEvaluationsLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AutoscaleEvaluationsLog'
      name: 'AutoscaleEvaluationsLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AutoscaleScaleActionsLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AutoscaleScaleActionsLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AutoscaleScaleActionsLog'
      name: 'AutoscaleScaleActionsLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVNMConnectivityConfigurationChange 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVNMConnectivityConfigurationChange'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVNMConnectivityConfigurationChange'
      name: 'AVNMConnectivityConfigurationChange'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVNMIPAMPoolAllocationChange 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVNMIPAMPoolAllocationChange'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVNMIPAMPoolAllocationChange'
      name: 'AVNMIPAMPoolAllocationChange'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVNMNetworkGroupMembershipChange 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVNMNetworkGroupMembershipChange'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVNMNetworkGroupMembershipChange'
      name: 'AVNMNetworkGroupMembershipChange'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVNMRuleCollectionChange 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVNMRuleCollectionChange'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVNMRuleCollectionChange'
      name: 'AVNMRuleCollectionChange'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVSEsxiFirewallSyslog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVSEsxiFirewallSyslog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVSEsxiFirewallSyslog'
      name: 'AVSEsxiFirewallSyslog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVSEsxiSyslog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVSEsxiSyslog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVSEsxiSyslog'
      name: 'AVSEsxiSyslog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVSNsxEdgeSyslog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVSNsxEdgeSyslog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVSNsxEdgeSyslog'
      name: 'AVSNsxEdgeSyslog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVSNsxManagerSyslog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVSNsxManagerSyslog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVSNsxManagerSyslog'
      name: 'AVSNsxManagerSyslog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVSSyslog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVSSyslog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVSSyslog'
      name: 'AVSSyslog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AVSVcSyslog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AVSVcSyslog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AVSVcSyslog'
      name: 'AVSVcSyslog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWApplicationRule 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWApplicationRule'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWApplicationRule'
      name: 'AZFWApplicationRule'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWApplicationRuleAggregation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWApplicationRuleAggregation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWApplicationRuleAggregation'
      name: 'AZFWApplicationRuleAggregation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWDnsFlowTrace 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWDnsFlowTrace'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWDnsFlowTrace'
      name: 'AZFWDnsFlowTrace'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWDnsQuery 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWDnsQuery'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWDnsQuery'
      name: 'AZFWDnsQuery'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWFatFlow 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWFatFlow'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWFatFlow'
      name: 'AZFWFatFlow'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWFlowTrace 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWFlowTrace'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWFlowTrace'
      name: 'AZFWFlowTrace'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWIdpsSignature 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWIdpsSignature'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWIdpsSignature'
      name: 'AZFWIdpsSignature'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWInternalFqdnResolutionFailure 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWInternalFqdnResolutionFailure'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWInternalFqdnResolutionFailure'
      name: 'AZFWInternalFqdnResolutionFailure'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWNatRule 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWNatRule'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWNatRule'
      name: 'AZFWNatRule'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWNatRuleAggregation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWNatRuleAggregation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWNatRuleAggregation'
      name: 'AZFWNatRuleAggregation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWNetworkRule 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWNetworkRule'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWNetworkRule'
      name: 'AZFWNetworkRule'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWNetworkRuleAggregation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWNetworkRuleAggregation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWNetworkRuleAggregation'
      name: 'AZFWNetworkRuleAggregation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZFWThreatIntel 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZFWThreatIntel'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZFWThreatIntel'
      name: 'AZFWThreatIntel'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZKVAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZKVAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZKVAuditLogs'
      name: 'AZKVAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZKVPolicyEvaluationDetailsLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZKVPolicyEvaluationDetailsLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZKVPolicyEvaluationDetailsLogs'
      name: 'AZKVPolicyEvaluationDetailsLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSApplicationMetricLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSApplicationMetricLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSApplicationMetricLogs'
      name: 'AZMSApplicationMetricLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSArchiveLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSArchiveLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSArchiveLogs'
      name: 'AZMSArchiveLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSAutoscaleLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSAutoscaleLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSAutoscaleLogs'
      name: 'AZMSAutoscaleLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSCustomerManagedKeyUserLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSCustomerManagedKeyUserLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSCustomerManagedKeyUserLogs'
      name: 'AZMSCustomerManagedKeyUserLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSDiagnosticErrorLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSDiagnosticErrorLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSDiagnosticErrorLogs'
      name: 'AZMSDiagnosticErrorLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSHybridConnectionsEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSHybridConnectionsEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSHybridConnectionsEvents'
      name: 'AZMSHybridConnectionsEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSKafkaCoordinatorLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSKafkaCoordinatorLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSKafkaCoordinatorLogs'
      name: 'AZMSKafkaCoordinatorLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSKafkaUserErrorLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSKafkaUserErrorLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSKafkaUserErrorLogs'
      name: 'AZMSKafkaUserErrorLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSOperationalLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSOperationalLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSOperationalLogs'
      name: 'AZMSOperationalLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSRunTimeAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSRunTimeAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSRunTimeAuditLogs'
      name: 'AZMSRunTimeAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AZMSVnetConnectionEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AZMSVnetConnectionEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AZMSVnetConnectionEvents'
      name: 'AZMSVnetConnectionEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureActivity 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureActivity'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'AzureActivity'
      name: 'AzureActivity'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_AzureActivityV2 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureActivityV2'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureActivityV2'
      name: 'AzureActivityV2'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureAssessmentRecommendation'
      name: 'AzureAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureAttestationDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureAttestationDiagnostics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureAttestationDiagnostics'
      name: 'AzureAttestationDiagnostics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureBackupOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureBackupOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureBackupOperations'
      name: 'AzureBackupOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureDevOpsAuditing 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureDevOpsAuditing'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureDevOpsAuditing'
      name: 'AzureDevOpsAuditing'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureDiagnostics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      columns: [
        {
          displayName: 'identity_claim_oid_g'
          name: 'identity_claim_oid_g'
          type: 'guid'
        }
        {
          displayName: 'identity_claim_scp_s'
          name: 'identity_claim_scp_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_appidacr_s'
          name: 'identity_claim_appidacr_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_iss_s'
          name: 'identity_claim_iss_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_xms_az_nwperimid_s'
          name: 'identity_claim_xms_az_nwperimid_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_upn_s'
          name: 'identity_claim_upn_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_idtyp_s'
          name: 'identity_claim_idtyp_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_ipaddr_s'
          name: 'identity_claim_ipaddr_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_unique_name_s'
          name: 'identity_claim_unique_name_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_amr_s'
          name: 'identity_claim_amr_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_uti_s'
          name: 'identity_claim_uti_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_iat_s'
          name: 'identity_claim_iat_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_exp_s'
          name: 'identity_claim_exp_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_aud_g'
          name: 'identity_claim_aud_g'
          type: 'guid'
        }
        {
          displayName: 'identity_claim_nbf_s'
          name: 'identity_claim_nbf_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_sid_g'
          name: 'identity_claim_sid_g'
          type: 'guid'
        }
        {
          displayName: 'isRbacAuthorized_b'
          name: 'isRbacAuthorized_b'
          type: 'boolean'
        }
        {
          displayName: 'appliedAssignmentId_g'
          name: 'appliedAssignmentId_g'
          type: 'guid'
        }
        {
          displayName: 'trustedService_s'
          name: 'trustedService_s'
          type: 'string'
        }
        {
          displayName: 'tlsVersion_s'
          name: 'tlsVersion_s'
          type: 'string'
        }
        {
          displayName: 'Category'
          name: 'Category'
          type: 'string'
        }
        {
          displayName: 'OperationName'
          name: 'OperationName'
          type: 'string'
        }
        {
          displayName: 'ResultType'
          name: 'ResultType'
          type: 'string'
        }
        {
          displayName: 'CorrelationId'
          name: 'CorrelationId'
          type: 'string'
        }
        {
          displayName: 'CallerIPAddress'
          name: 'CallerIPAddress'
          type: 'string'
        }
        {
          displayName: 'identity_claim_http_schemas_microsoft_com_identity_claims_objectidentifier_g'
          name: 'identity_claim_http_schemas_microsoft_com_identity_claims_objectidentifier_g'
          type: 'guid'
        }
        {
          displayName: 'identity_claim_http_schemas_xmlsoap_org_ws_2005_05_identity_claims_upn_s'
          name: 'identity_claim_http_schemas_xmlsoap_org_ws_2005_05_identity_claims_upn_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_http_schemas_xmlsoap_org_ws_2005_05_identity_claims_name_s'
          name: 'identity_claim_http_schemas_xmlsoap_org_ws_2005_05_identity_claims_name_s'
          type: 'string'
        }
        {
          displayName: 'identity_claim_appid_g'
          name: 'identity_claim_appid_g'
          type: 'guid'
        }
        {
          displayName: 'id_s'
          name: 'id_s'
          type: 'string'
        }
        {
          displayName: 'clientInfo_s'
          name: 'clientInfo_s'
          type: 'string'
        }
        {
          displayName: 'requestUri_s'
          name: 'requestUri_s'
          type: 'string'
        }
        {
          displayName: 'httpStatusCode_d'
          name: 'httpStatusCode_d'
          type: 'real'
        }
        {
          displayName: 'properties_sku_Family_s'
          name: 'properties_sku_Family_s'
          type: 'string'
        }
        {
          displayName: 'properties_sku_Name_s'
          name: 'properties_sku_Name_s'
          type: 'string'
        }
        {
          displayName: 'properties_tenantId_g'
          name: 'properties_tenantId_g'
          type: 'guid'
        }
        {
          displayName: 'properties_enabledForDeployment_b'
          name: 'properties_enabledForDeployment_b'
          type: 'boolean'
        }
        {
          displayName: 'properties_enabledForDiskEncryption_b'
          name: 'properties_enabledForDiskEncryption_b'
          type: 'boolean'
        }
        {
          displayName: 'properties_enabledForTemplateDeployment_b'
          name: 'properties_enabledForTemplateDeployment_b'
          type: 'boolean'
        }
        {
          displayName: 'properties_enableSoftDelete_b'
          name: 'properties_enableSoftDelete_b'
          type: 'boolean'
        }
        {
          displayName: 'properties_softDeleteRetentionInDays_d'
          name: 'properties_softDeleteRetentionInDays_d'
          type: 'real'
        }
        {
          displayName: 'properties_enableRbacAuthorization_b'
          name: 'properties_enableRbacAuthorization_b'
          type: 'boolean'
        }
        {
          displayName: 'properties_enableCrossTenantAccessProtection_b'
          name: 'properties_enableCrossTenantAccessProtection_b'
          type: 'boolean'
        }
        {
          displayName: 'ResourceId'
          name: 'ResourceId'
          type: 'string'
        }
        {
          displayName: 'OperationVersion'
          name: 'OperationVersion'
          type: 'string'
        }
        {
          displayName: 'ResultSignature'
          name: 'ResultSignature'
          type: 'string'
        }
        {
          displayName: 'DurationMs'
          name: 'DurationMs'
          type: 'long'
        }
        {
          displayName: 'SubscriptionId'
          name: 'SubscriptionId'
          type: 'guid'
        }
        {
          displayName: 'ResourceGroup'
          name: 'ResourceGroup'
          type: 'string'
        }
        {
          displayName: 'ResourceProvider'
          name: 'ResourceProvider'
          type: 'string'
        }
        {
          displayName: 'Resource'
          name: 'Resource'
          type: 'string'
        }
        {
          displayName: 'ResourceType'
          name: 'ResourceType'
          type: 'string'
        }
        {
          displayName: 'AdditionalFields'
          name: '_CustomFieldsCollection'
          type: 'dynamic'
        }
      ]
      displayName: 'AzureDiagnostics'
      name: 'AzureDiagnostics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureLoadTestingOperation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureLoadTestingOperation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureLoadTestingOperation'
      name: 'AzureLoadTestingOperation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureMetrics'
      name: 'AzureMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureMetricsV2 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureMetricsV2'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureMetricsV2'
      name: 'AzureMetricsV2'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureMonitorPipelineLogErrors 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureMonitorPipelineLogErrors'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureMonitorPipelineLogErrors'
      name: 'AzureMonitorPipelineLogErrors'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLAutomaticTuning 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLAutomaticTuning'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLAutomaticTuning'
      name: 'AzureSQLAutomaticTuning'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLBlocks 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLBlocks'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLBlocks'
      name: 'AzureSQLBlocks'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLDatabaseWaitStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLDatabaseWaitStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLDatabaseWaitStatistics'
      name: 'AzureSQLDatabaseWaitStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLDeadlocks 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLDeadlocks'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLDeadlocks'
      name: 'AzureSQLDeadlocks'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLErrors 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLErrors'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLErrors'
      name: 'AzureSQLErrors'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLQueryStoreRuntimeStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLQueryStoreRuntimeStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLQueryStoreRuntimeStatistics'
      name: 'AzureSQLQueryStoreRuntimeStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLQueryStoreWaitStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLQueryStoreWaitStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLQueryStoreWaitStatistics'
      name: 'AzureSQLQueryStoreWaitStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLResourceUsageStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLResourceUsageStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLResourceUsageStats'
      name: 'AzureSQLResourceUsageStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_AzureSQLTimeouts 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'AzureSQLTimeouts'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'AzureSQLTimeouts'
      name: 'AzureSQLTimeouts'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_BehaviorEntities 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'BehaviorEntities'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'BehaviorEntities'
      name: 'BehaviorEntities'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_BehaviorInfo 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'BehaviorInfo'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'BehaviorInfo'
      name: 'BehaviorInfo'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_BlockchainApplicationLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'BlockchainApplicationLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'BlockchainApplicationLog'
      name: 'BlockchainApplicationLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_BlockchainProxyLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'BlockchainProxyLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'BlockchainProxyLog'
      name: 'BlockchainProxyLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CassandraAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CassandraAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CassandraAudit'
      name: 'CassandraAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CassandraLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CassandraLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CassandraLogs'
      name: 'CassandraLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CCFApplicationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CCFApplicationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CCFApplicationLogs'
      name: 'CCFApplicationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBCassandraRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBCassandraRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBCassandraRequests'
      name: 'CDBCassandraRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBControlPlaneRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBControlPlaneRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBControlPlaneRequests'
      name: 'CDBControlPlaneRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBDataPlaneRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBDataPlaneRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBDataPlaneRequests'
      name: 'CDBDataPlaneRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBDataPlaneRequests15M 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBDataPlaneRequests15M'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBDataPlaneRequests15M'
      name: 'CDBDataPlaneRequests15M'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBDataPlaneRequests5M 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBDataPlaneRequests5M'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBDataPlaneRequests5M'
      name: 'CDBDataPlaneRequests5M'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBGremlinRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBGremlinRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBGremlinRequests'
      name: 'CDBGremlinRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBMongoRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBMongoRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBMongoRequests'
      name: 'CDBMongoRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBPartitionKeyRUConsumption 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBPartitionKeyRUConsumption'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBPartitionKeyRUConsumption'
      name: 'CDBPartitionKeyRUConsumption'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBPartitionKeyStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBPartitionKeyStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBPartitionKeyStatistics'
      name: 'CDBPartitionKeyStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBQueryRuntimeStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBQueryRuntimeStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBQueryRuntimeStatistics'
      name: 'CDBQueryRuntimeStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CDBTableApiRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CDBTableApiRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CDBTableApiRequests'
      name: 'CDBTableApiRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ChaosStudioExperimentEventLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ChaosStudioExperimentEventLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ChaosStudioExperimentEventLogs'
      name: 'ChaosStudioExperimentEventLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CHSMServiceOperationAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CHSMServiceOperationAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CHSMServiceOperationAuditLogs'
      name: 'CHSMServiceOperationAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CIEventsAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CIEventsAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CIEventsAudit'
      name: 'CIEventsAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CIEventsOperational 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CIEventsOperational'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CIEventsOperational'
      name: 'CIEventsOperational'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CloudHsmHardwareOperationAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CloudHsmHardwareOperationAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CloudHsmHardwareOperationAuditLogs'
      name: 'CloudHsmHardwareOperationAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CloudHsmServiceOperationAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CloudHsmServiceOperationAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CloudHsmServiceOperationAuditLogs'
      name: 'CloudHsmServiceOperationAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ComputerGroup 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ComputerGroup'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ComputerGroup'
      name: 'ComputerGroup'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerAppConsoleLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerAppConsoleLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerAppConsoleLogs'
      name: 'ContainerAppConsoleLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerAppHTTPLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerAppHTTPLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerAppHTTPLogs'
      name: 'ContainerAppHTTPLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerAppSystemLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerAppSystemLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerAppSystemLogs'
      name: 'ContainerAppSystemLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerEvent'
      name: 'ContainerEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerImageInventory 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerImageInventory'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerImageInventory'
      name: 'ContainerImageInventory'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerInstanceLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerInstanceLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerInstanceLog'
      name: 'ContainerInstanceLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerInventory 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerInventory'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerInventory'
      name: 'ContainerInventory'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerLog'
      name: 'ContainerLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerLogV2 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerLogV2'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerLogV2'
      name: 'ContainerLogV2'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerNetworkLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerNetworkLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerNetworkLogs'
      name: 'ContainerNetworkLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerNodeInventory 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerNodeInventory'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerNodeInventory'
      name: 'ContainerNodeInventory'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerRegistryLoginEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerRegistryLoginEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerRegistryLoginEvents'
      name: 'ContainerRegistryLoginEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerRegistryRepositoryEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerRegistryRepositoryEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerRegistryRepositoryEvents'
      name: 'ContainerRegistryRepositoryEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ContainerServiceLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ContainerServiceLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ContainerServiceLog'
      name: 'ContainerServiceLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_CoreAzureBackup 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'CoreAzureBackup'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'CoreAzureBackup'
      name: 'CoreAzureBackup'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksAccounts 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksAccounts'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksAccounts'
      name: 'DatabricksAccounts'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksApps 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksApps'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksApps'
      name: 'DatabricksApps'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksBrickStoreHttpGateway 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksBrickStoreHttpGateway'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksBrickStoreHttpGateway'
      name: 'DatabricksBrickStoreHttpGateway'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksBudgetPolicyCentral 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksBudgetPolicyCentral'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksBudgetPolicyCentral'
      name: 'DatabricksBudgetPolicyCentral'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksCapsule8Dataplane 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksCapsule8Dataplane'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksCapsule8Dataplane'
      name: 'DatabricksCapsule8Dataplane'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksClamAVScan 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksClamAVScan'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksClamAVScan'
      name: 'DatabricksClamAVScan'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksCloudStorageMetadata 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksCloudStorageMetadata'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksCloudStorageMetadata'
      name: 'DatabricksCloudStorageMetadata'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksClusterLibraries 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksClusterLibraries'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksClusterLibraries'
      name: 'DatabricksClusterLibraries'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksClusterPolicies 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksClusterPolicies'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksClusterPolicies'
      name: 'DatabricksClusterPolicies'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksClusters 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksClusters'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksClusters'
      name: 'DatabricksClusters'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksDashboards 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksDashboards'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksDashboards'
      name: 'DatabricksDashboards'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksDatabricksSQL 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksDatabricksSQL'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksDatabricksSQL'
      name: 'DatabricksDatabricksSQL'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksDataMonitoring 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksDataMonitoring'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksDataMonitoring'
      name: 'DatabricksDataMonitoring'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksDataRooms 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksDataRooms'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksDataRooms'
      name: 'DatabricksDataRooms'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksDBFS 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksDBFS'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksDBFS'
      name: 'DatabricksDBFS'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksDeltaPipelines 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksDeltaPipelines'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksDeltaPipelines'
      name: 'DatabricksDeltaPipelines'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksFeatureStore 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksFeatureStore'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksFeatureStore'
      name: 'DatabricksFeatureStore'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksFiles 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksFiles'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksFiles'
      name: 'DatabricksFiles'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksFilesystem 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksFilesystem'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksFilesystem'
      name: 'DatabricksFilesystem'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksGenie 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksGenie'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksGenie'
      name: 'DatabricksGenie'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksGitCredentials 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksGitCredentials'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksGitCredentials'
      name: 'DatabricksGitCredentials'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksGlobalInitScripts 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksGlobalInitScripts'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksGlobalInitScripts'
      name: 'DatabricksGlobalInitScripts'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksGroups 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksGroups'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksGroups'
      name: 'DatabricksGroups'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksIAMRole 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksIAMRole'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksIAMRole'
      name: 'DatabricksIAMRole'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksIngestion 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksIngestion'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksIngestion'
      name: 'DatabricksIngestion'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksInstancePools 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksInstancePools'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksInstancePools'
      name: 'DatabricksInstancePools'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksJobs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksJobs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksJobs'
      name: 'DatabricksJobs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksLakeviewConfig 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksLakeviewConfig'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksLakeviewConfig'
      name: 'DatabricksLakeviewConfig'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksLineageTracking 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksLineageTracking'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksLineageTracking'
      name: 'DatabricksLineageTracking'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksMarketplaceConsumer 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksMarketplaceConsumer'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksMarketplaceConsumer'
      name: 'DatabricksMarketplaceConsumer'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksMarketplaceProvider 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksMarketplaceProvider'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksMarketplaceProvider'
      name: 'DatabricksMarketplaceProvider'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksMLflowAcledArtifact 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksMLflowAcledArtifact'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksMLflowAcledArtifact'
      name: 'DatabricksMLflowAcledArtifact'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksMLflowExperiment 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksMLflowExperiment'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksMLflowExperiment'
      name: 'DatabricksMLflowExperiment'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksModelRegistry 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksModelRegistry'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksModelRegistry'
      name: 'DatabricksModelRegistry'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksNotebook 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksNotebook'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksNotebook'
      name: 'DatabricksNotebook'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksOnlineTables 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksOnlineTables'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksOnlineTables'
      name: 'DatabricksOnlineTables'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksPartnerHub 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksPartnerHub'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksPartnerHub'
      name: 'DatabricksPartnerHub'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksPredictiveOptimization 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksPredictiveOptimization'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksPredictiveOptimization'
      name: 'DatabricksPredictiveOptimization'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksRBAC 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksRBAC'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksRBAC'
      name: 'DatabricksRBAC'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksRemoteHistoryService 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksRemoteHistoryService'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksRemoteHistoryService'
      name: 'DatabricksRemoteHistoryService'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksRepos 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksRepos'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksRepos'
      name: 'DatabricksRepos'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksRFA 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksRFA'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksRFA'
      name: 'DatabricksRFA'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksSecrets 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksSecrets'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksSecrets'
      name: 'DatabricksSecrets'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksServerlessRealTimeInference 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksServerlessRealTimeInference'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksServerlessRealTimeInference'
      name: 'DatabricksServerlessRealTimeInference'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksSQL 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksSQL'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksSQL'
      name: 'DatabricksSQL'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksSQLPermissions 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksSQLPermissions'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksSQLPermissions'
      name: 'DatabricksSQLPermissions'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksSSH 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksSSH'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksSSH'
      name: 'DatabricksSSH'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksTables 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksTables'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksTables'
      name: 'DatabricksTables'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksUnityCatalog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksUnityCatalog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksUnityCatalog'
      name: 'DatabricksUnityCatalog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksVectorSearch 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksVectorSearch'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksVectorSearch'
      name: 'DatabricksVectorSearch'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksWebhookNotifications 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksWebhookNotifications'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksWebhookNotifications'
      name: 'DatabricksWebhookNotifications'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksWebTerminal 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksWebTerminal'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksWebTerminal'
      name: 'DatabricksWebTerminal'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksWorkspace 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksWorkspace'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksWorkspace'
      name: 'DatabricksWorkspace'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DatabricksWorkspaceFiles 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DatabricksWorkspaceFiles'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DatabricksWorkspaceFiles'
      name: 'DatabricksWorkspaceFiles'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DataSetOutput 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DataSetOutput'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DataSetOutput'
      name: 'DataSetOutput'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DataSetRuns 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DataSetRuns'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DataSetRuns'
      name: 'DataSetRuns'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DataTransferOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DataTransferOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DataTransferOperations'
      name: 'DataTransferOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DCRLogErrors 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DCRLogErrors'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DCRLogErrors'
      name: 'DCRLogErrors'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DCRLogTroubleshooting 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DCRLogTroubleshooting'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DCRLogTroubleshooting'
      name: 'DCRLogTroubleshooting'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DevCenterAgentHealthLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DevCenterAgentHealthLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DevCenterAgentHealthLogs'
      name: 'DevCenterAgentHealthLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DevCenterBillingEventLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DevCenterBillingEventLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DevCenterBillingEventLogs'
      name: 'DevCenterBillingEventLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DevCenterConnectionLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DevCenterConnectionLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DevCenterConnectionLogs'
      name: 'DevCenterConnectionLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DevCenterDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DevCenterDiagnosticLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DevCenterDiagnosticLogs'
      name: 'DevCenterDiagnosticLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DevCenterResourceOperationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DevCenterResourceOperationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DevCenterResourceOperationLogs'
      name: 'DevCenterResourceOperationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceBehaviorEntities 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceBehaviorEntities'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceBehaviorEntities'
      name: 'DeviceBehaviorEntities'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceBehaviorInfo 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceBehaviorInfo'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceBehaviorInfo'
      name: 'DeviceBehaviorInfo'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceCustomFileEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceCustomFileEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceCustomFileEvents'
      name: 'DeviceCustomFileEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceCustomImageLoadEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceCustomImageLoadEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceCustomImageLoadEvents'
      name: 'DeviceCustomImageLoadEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceCustomNetworkEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceCustomNetworkEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceCustomNetworkEvents'
      name: 'DeviceCustomNetworkEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceCustomProcessEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceCustomProcessEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceCustomProcessEvents'
      name: 'DeviceCustomProcessEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceCustomRegistryEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceCustomRegistryEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceCustomRegistryEvents'
      name: 'DeviceCustomRegistryEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DeviceCustomScriptEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DeviceCustomScriptEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DeviceCustomScriptEvents'
      name: 'DeviceCustomScriptEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DevOpsOperationsAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DevOpsOperationsAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DevOpsOperationsAudit'
      name: 'DevOpsOperationsAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DiscoveryBookshelfAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DiscoveryBookshelfAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DiscoveryBookshelfAuditLogs'
      name: 'DiscoveryBookshelfAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DiscoverySupercomputerAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DiscoverySupercomputerAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DiscoverySupercomputerAuditLogs'
      name: 'DiscoverySupercomputerAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DiscoveryWorkspaceAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DiscoveryWorkspaceAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DiscoveryWorkspaceAuditLogs'
      name: 'DiscoveryWorkspaceAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DNSQueryLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DNSQueryLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DNSQueryLogs'
      name: 'DNSQueryLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DragonCopilot 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DragonCopilot'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DragonCopilot'
      name: 'DragonCopilot'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DSMAzureBlobStorageLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DSMAzureBlobStorageLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DSMAzureBlobStorageLogs'
      name: 'DSMAzureBlobStorageLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DSMDataClassificationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DSMDataClassificationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DSMDataClassificationLogs'
      name: 'DSMDataClassificationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DSMDataLabelingLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DSMDataLabelingLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DSMDataLabelingLogs'
      name: 'DSMDataLabelingLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_DurableTaskSchedulerLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'DurableTaskSchedulerLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'DurableTaskSchedulerLogs'
      name: 'DurableTaskSchedulerLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EdgeActionConsoleLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EdgeActionConsoleLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EdgeActionConsoleLog'
      name: 'EdgeActionConsoleLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EdgeActionServiceLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EdgeActionServiceLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EdgeActionServiceLog'
      name: 'EdgeActionServiceLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EdgeSecurityEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EdgeSecurityEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EdgeSecurityEvents'
      name: 'EdgeSecurityEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EGNFailedHttpDataPlaneOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EGNFailedHttpDataPlaneOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EGNFailedHttpDataPlaneOperations'
      name: 'EGNFailedHttpDataPlaneOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EGNFailedMqttConnections 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EGNFailedMqttConnections'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EGNFailedMqttConnections'
      name: 'EGNFailedMqttConnections'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EGNFailedMqttPublishedMessages 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EGNFailedMqttPublishedMessages'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EGNFailedMqttPublishedMessages'
      name: 'EGNFailedMqttPublishedMessages'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EGNFailedMqttSubscriptions 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EGNFailedMqttSubscriptions'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EGNFailedMqttSubscriptions'
      name: 'EGNFailedMqttSubscriptions'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EGNMqttDisconnections 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EGNMqttDisconnections'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EGNMqttDisconnections'
      name: 'EGNMqttDisconnections'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EGNSuccessfulHttpDataPlaneOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EGNSuccessfulHttpDataPlaneOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EGNSuccessfulHttpDataPlaneOperations'
      name: 'EGNSuccessfulHttpDataPlaneOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EGNSuccessfulMqttConnections 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EGNSuccessfulMqttConnections'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EGNSuccessfulMqttConnections'
      name: 'EGNSuccessfulMqttConnections'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_EnrichedMicrosoft365AuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'EnrichedMicrosoft365AuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'EnrichedMicrosoft365AuditLogs'
      name: 'EnrichedMicrosoft365AuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ETWEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ETWEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ETWEvent'
      name: 'ETWEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Event 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Event'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Event'
      name: 'Event'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ExchangeAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ExchangeAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ExchangeAssessmentRecommendation'
      name: 'ExchangeAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ExchangeOnlineAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ExchangeOnlineAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ExchangeOnlineAssessmentRecommendation'
      name: 'ExchangeOnlineAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_FailedIngestion 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'FailedIngestion'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'FailedIngestion'
      name: 'FailedIngestion'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_FunctionAppLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'FunctionAppLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'FunctionAppLogs'
      name: 'FunctionAppLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_GraphNotificationsActivityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'GraphNotificationsActivityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'GraphNotificationsActivityLogs'
      name: 'GraphNotificationsActivityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightAmbariClusterAlerts 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightAmbariClusterAlerts'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightAmbariClusterAlerts'
      name: 'HDInsightAmbariClusterAlerts'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightAmbariSystemMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightAmbariSystemMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightAmbariSystemMetrics'
      name: 'HDInsightAmbariSystemMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightGatewayAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightGatewayAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightGatewayAuditLogs'
      name: 'HDInsightGatewayAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHadoopAndYarnLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHadoopAndYarnLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHadoopAndYarnLogs'
      name: 'HDInsightHadoopAndYarnLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHadoopAndYarnMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHadoopAndYarnMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHadoopAndYarnMetrics'
      name: 'HDInsightHadoopAndYarnMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHBaseLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHBaseLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHBaseLogs'
      name: 'HDInsightHBaseLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHBaseMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHBaseMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHBaseMetrics'
      name: 'HDInsightHBaseMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHiveAndLLAPLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHiveAndLLAPLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHiveAndLLAPLogs'
      name: 'HDInsightHiveAndLLAPLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHiveAndLLAPMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHiveAndLLAPMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHiveAndLLAPMetrics'
      name: 'HDInsightHiveAndLLAPMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHiveQueryAppStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHiveQueryAppStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHiveQueryAppStats'
      name: 'HDInsightHiveQueryAppStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightHiveTezAppStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightHiveTezAppStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightHiveTezAppStats'
      name: 'HDInsightHiveTezAppStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightJupyterNotebookEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightJupyterNotebookEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightJupyterNotebookEvents'
      name: 'HDInsightJupyterNotebookEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightKafkaLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightKafkaLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightKafkaLogs'
      name: 'HDInsightKafkaLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightKafkaMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightKafkaMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightKafkaMetrics'
      name: 'HDInsightKafkaMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightKafkaServerLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightKafkaServerLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightKafkaServerLog'
      name: 'HDInsightKafkaServerLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightOozieLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightOozieLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightOozieLogs'
      name: 'HDInsightOozieLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightRangerAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightRangerAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightRangerAuditLogs'
      name: 'HDInsightRangerAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSecurityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSecurityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSecurityLogs'
      name: 'HDInsightSecurityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkApplicationEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkApplicationEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkApplicationEvents'
      name: 'HDInsightSparkApplicationEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkBlockManagerEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkBlockManagerEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkBlockManagerEvents'
      name: 'HDInsightSparkBlockManagerEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkEnvironmentEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkEnvironmentEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkEnvironmentEvents'
      name: 'HDInsightSparkEnvironmentEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkExecutorEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkExecutorEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkExecutorEvents'
      name: 'HDInsightSparkExecutorEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkExtraEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkExtraEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkExtraEvents'
      name: 'HDInsightSparkExtraEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkJobEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkJobEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkJobEvents'
      name: 'HDInsightSparkJobEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkLogs'
      name: 'HDInsightSparkLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkSQLExecutionEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkSQLExecutionEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkSQLExecutionEvents'
      name: 'HDInsightSparkSQLExecutionEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkStageEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkStageEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkStageEvents'
      name: 'HDInsightSparkStageEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkStageTaskAccumulables 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkStageTaskAccumulables'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkStageTaskAccumulables'
      name: 'HDInsightSparkStageTaskAccumulables'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightSparkTaskEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightSparkTaskEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightSparkTaskEvents'
      name: 'HDInsightSparkTaskEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightStormLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightStormLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightStormLogs'
      name: 'HDInsightStormLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightStormMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightStormMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightStormMetrics'
      name: 'HDInsightStormMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HDInsightStormTopologyMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HDInsightStormTopologyMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HDInsightStormTopologyMetrics'
      name: 'HDInsightStormTopologyMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HealthStateChangeEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HealthStateChangeEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HealthStateChangeEvent'
      name: 'HealthStateChangeEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Heartbeat 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Heartbeat'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Heartbeat'
      name: 'Heartbeat'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HorizonDBAutovacuumStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HorizonDBAutovacuumStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HorizonDBAutovacuumStats'
      name: 'HorizonDBAutovacuumStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HorizonDBPgStatActivitySessions 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HorizonDBPgStatActivitySessions'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HorizonDBPgStatActivitySessions'
      name: 'HorizonDBPgStatActivitySessions'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HorizonDBQueryStoreQueryText 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HorizonDBQueryStoreQueryText'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HorizonDBQueryStoreQueryText'
      name: 'HorizonDBQueryStoreQueryText'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HorizonDBQueryStoreRuntimeStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HorizonDBQueryStoreRuntimeStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HorizonDBQueryStoreRuntimeStats'
      name: 'HorizonDBQueryStoreRuntimeStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HorizonDBQueryStoreWaitsStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HorizonDBQueryStoreWaitsStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HorizonDBQueryStoreWaitsStats'
      name: 'HorizonDBQueryStoreWaitsStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HorizonDBServerLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HorizonDBServerLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HorizonDBServerLogs'
      name: 'HorizonDBServerLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_HorizonDBTransactionsStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'HorizonDBTransactionsStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'HorizonDBTransactionsStats'
      name: 'HorizonDBTransactionsStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_InsightsMetrics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'InsightsMetrics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'InsightsMetrics'
      name: 'InsightsMetrics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_IntuneAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'IntuneAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'IntuneAuditLogs'
      name: 'IntuneAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_IntuneDeviceComplianceOrg 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'IntuneDeviceComplianceOrg'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'IntuneDeviceComplianceOrg'
      name: 'IntuneDeviceComplianceOrg'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_IntuneDevices 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'IntuneDevices'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'IntuneDevices'
      name: 'IntuneDevices'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_IntuneOperationalLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'IntuneOperationalLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'IntuneOperationalLogs'
      name: 'IntuneOperationalLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_KubeEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'KubeEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'KubeEvents'
      name: 'KubeEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_KubeHealth 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'KubeHealth'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'KubeHealth'
      name: 'KubeHealth'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_KubeMonAgentEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'KubeMonAgentEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'KubeMonAgentEvents'
      name: 'KubeMonAgentEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_KubeNodeInventory 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'KubeNodeInventory'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'KubeNodeInventory'
      name: 'KubeNodeInventory'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_KubePodInventory 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'KubePodInventory'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'KubePodInventory'
      name: 'KubePodInventory'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_KubePVInventory 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'KubePVInventory'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'KubePVInventory'
      name: 'KubePVInventory'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_KubeServices 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'KubeServices'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'KubeServices'
      name: 'KubeServices'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_LAJobLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LAJobLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'LAJobLogs'
      name: 'LAJobLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_LAQueryLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LAQueryLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'LAQueryLogs'
      name: 'LAQueryLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_LASummaryLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LASummaryLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'LASummaryLogs'
      name: 'LASummaryLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_LedgerTransactionLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LedgerTransactionLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'LedgerTransactionLogs'
      name: 'LedgerTransactionLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_LedgerUserDefinedLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LedgerUserDefinedLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'LedgerUserDefinedLogs'
      name: 'LedgerUserDefinedLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_LIATrackingEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LIATrackingEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'LIATrackingEvents'
      name: 'LIATrackingEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_LogicAppWorkflowRuntime 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'LogicAppWorkflowRuntime'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'LogicAppWorkflowRuntime'
      name: 'LogicAppWorkflowRuntime'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MCCEventLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MCCEventLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MCCEventLogs'
      name: 'MCCEventLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MCVPAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MCVPAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MCVPAuditLogs'
      name: 'MCVPAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MCVPOperationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MCVPOperationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MCVPOperationLogs'
      name: 'MCVPOperationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDCDetectionDNSEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDCDetectionDNSEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDCDetectionDNSEvents'
      name: 'MDCDetectionDNSEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDCDetectionFimEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDCDetectionFimEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDCDetectionFimEvents'
      name: 'MDCDetectionFimEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDCDetectionGatingValidationEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDCDetectionGatingValidationEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDCDetectionGatingValidationEvents'
      name: 'MDCDetectionGatingValidationEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDCDetectionK8SApiEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDCDetectionK8SApiEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDCDetectionK8SApiEvents'
      name: 'MDCDetectionK8SApiEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDCDetectionProcessV2Events 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDCDetectionProcessV2Events'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDCDetectionProcessV2Events'
      name: 'MDCDetectionProcessV2Events'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDCFileIntegrityMonitoringEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDCFileIntegrityMonitoringEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDCFileIntegrityMonitoringEvents'
      name: 'MDCFileIntegrityMonitoringEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDECustomCollectionDeviceFileEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDECustomCollectionDeviceFileEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDECustomCollectionDeviceFileEvents'
      name: 'MDECustomCollectionDeviceFileEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MDPResourceLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MDPResourceLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MDPResourceLog'
      name: 'MDPResourceLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MeshControlPlane 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MeshControlPlane'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MeshControlPlane'
      name: 'MeshControlPlane'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftAzureBastionAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftAzureBastionAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftAzureBastionAuditLogs'
      name: 'MicrosoftAzureBastionAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftDataShareReceivedSnapshotLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftDataShareReceivedSnapshotLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftDataShareReceivedSnapshotLog'
      name: 'MicrosoftDataShareReceivedSnapshotLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftDataShareSentSnapshotLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftDataShareSentSnapshotLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftDataShareSentSnapshotLog'
      name: 'MicrosoftDataShareSentSnapshotLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftDataShareShareLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftDataShareShareLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftDataShareShareLog'
      name: 'MicrosoftDataShareShareLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftGraphActivityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftGraphActivityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftGraphActivityLogs'
      name: 'MicrosoftGraphActivityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftGraphPolicyLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftGraphPolicyLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftGraphPolicyLogs'
      name: 'MicrosoftGraphPolicyLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftHealthcareApisAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftHealthcareApisAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftHealthcareApisAuditLogs'
      name: 'MicrosoftHealthcareApisAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MicrosoftServicePrincipalSignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MicrosoftServicePrincipalSignInLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MicrosoftServicePrincipalSignInLogs'
      name: 'MicrosoftServicePrincipalSignInLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MNFDeviceUpdates 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MNFDeviceUpdates'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MNFDeviceUpdates'
      name: 'MNFDeviceUpdates'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MNFSystemSessionHistoryUpdates 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MNFSystemSessionHistoryUpdates'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MNFSystemSessionHistoryUpdates'
      name: 'MNFSystemSessionHistoryUpdates'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MNFSystemStateMessageUpdates 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MNFSystemStateMessageUpdates'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MNFSystemStateMessageUpdates'
      name: 'MNFSystemStateMessageUpdates'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MPCAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MPCAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MPCAuditLogs'
      name: 'MPCAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MPCIngestionLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MPCIngestionLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MPCIngestionLogs'
      name: 'MPCIngestionLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MySqlAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MySqlAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MySqlAuditLogs'
      name: 'MySqlAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_MySqlSlowLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'MySqlSlowLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'MySqlSlowLogs'
      name: 'MySqlSlowLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NatGatewayFlowlogsV1 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NatGatewayFlowlogsV1'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NatGatewayFlowlogsV1'
      name: 'NatGatewayFlowlogsV1'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCBMBreakGlassAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCBMBreakGlassAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCBMBreakGlassAuditLogs'
      name: 'NCBMBreakGlassAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCBMSecurityDefenderLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCBMSecurityDefenderLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCBMSecurityDefenderLogs'
      name: 'NCBMSecurityDefenderLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCBMSecurityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCBMSecurityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCBMSecurityLogs'
      name: 'NCBMSecurityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCBMSystemLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCBMSystemLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCBMSystemLogs'
      name: 'NCBMSystemLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCCIDRACLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCCIDRACLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCCIDRACLogs'
      name: 'NCCIDRACLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCCKubernetesAPIAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCCKubernetesAPIAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCCKubernetesAPIAuditLogs'
      name: 'NCCKubernetesAPIAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCCKubernetesLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCCKubernetesLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCCKubernetesLogs'
      name: 'NCCKubernetesLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCCPlatformOperationsLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCCPlatformOperationsLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCCPlatformOperationsLogs'
      name: 'NCCPlatformOperationsLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCCVMOrchestrationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCCVMOrchestrationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCCVMOrchestrationLogs'
      name: 'NCCVMOrchestrationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCMClusterOperationsLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCMClusterOperationsLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCMClusterOperationsLogs'
      name: 'NCMClusterOperationsLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCSStorageAlerts 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCSStorageAlerts'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCSStorageAlerts'
      name: 'NCSStorageAlerts'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCSStorageAudits 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCSStorageAudits'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCSStorageAudits'
      name: 'NCSStorageAudits'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NCSStorageLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NCSStorageLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NCSStorageLogs'
      name: 'NCSStorageLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NetworkAccessAlerts 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NetworkAccessAlerts'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NetworkAccessAlerts'
      name: 'NetworkAccessAlerts'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NetworkAccessConnectionEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NetworkAccessConnectionEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NetworkAccessConnectionEvents'
      name: 'NetworkAccessConnectionEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NetworkAccessGenerativeAIInsights 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NetworkAccessGenerativeAIInsights'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NetworkAccessGenerativeAIInsights'
      name: 'NetworkAccessGenerativeAIInsights'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NetworkAccessTraffic 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NetworkAccessTraffic'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NetworkAccessTraffic'
      name: 'NetworkAccessTraffic'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NginxUpstreamUpdateLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NginxUpstreamUpdateLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NginxUpstreamUpdateLogs'
      name: 'NginxUpstreamUpdateLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NGXOperationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NGXOperationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NGXOperationLogs'
      name: 'NGXOperationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NGXSecurityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NGXSecurityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NGXSecurityLogs'
      name: 'NGXSecurityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NSPAccessLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NSPAccessLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NSPAccessLogs'
      name: 'NSPAccessLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NTAInsights 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NTAInsights'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NTAInsights'
      name: 'NTAInsights'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NTAIpDetails 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NTAIpDetails'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NTAIpDetails'
      name: 'NTAIpDetails'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NTANetAnalytics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NTANetAnalytics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NTANetAnalytics'
      name: 'NTANetAnalytics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NTANspRuleRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NTANspRuleRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NTANspRuleRecommendation'
      name: 'NTANspRuleRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NTARuleRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NTARuleRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NTARuleRecommendation'
      name: 'NTARuleRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NTATopologyDetails 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NTATopologyDetails'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NTATopologyDetails'
      name: 'NTATopologyDetails'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NWConnectionMonitorDNSResult 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NWConnectionMonitorDNSResult'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NWConnectionMonitorDNSResult'
      name: 'NWConnectionMonitorDNSResult'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NWConnectionMonitorPathResult 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NWConnectionMonitorPathResult'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NWConnectionMonitorPathResult'
      name: 'NWConnectionMonitorPathResult'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NWConnectionMonitorTestResult 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NWConnectionMonitorTestResult'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NWConnectionMonitorTestResult'
      name: 'NWConnectionMonitorTestResult'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NWPacketCaptureDnsQuery 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NWPacketCaptureDnsQuery'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NWPacketCaptureDnsQuery'
      name: 'NWPacketCaptureDnsQuery'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NWPacketCaptureHttpTransaction 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NWPacketCaptureHttpTransaction'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NWPacketCaptureHttpTransaction'
      name: 'NWPacketCaptureHttpTransaction'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NWPacketCaptureNetworkSession 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NWPacketCaptureNetworkSession'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NWPacketCaptureNetworkSession'
      name: 'NWPacketCaptureNetworkSession'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_NWPacketCaptureTlsSession 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'NWPacketCaptureTlsSession'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'NWPacketCaptureTlsSession'
      name: 'NWPacketCaptureTlsSession'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ODSPFiles 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ODSPFiles'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ODSPFiles'
      name: 'ODSPFiles'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEPAirFlowTask 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEPAirFlowTask'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEPAirFlowTask'
      name: 'OEPAirFlowTask'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEPAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEPAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEPAuditLogs'
      name: 'OEPAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEPDataplaneLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEPDataplaneLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEPDataplaneLogs'
      name: 'OEPDataplaneLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEPElasticOperator 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEPElasticOperator'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEPElasticOperator'
      name: 'OEPElasticOperator'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEPElasticsearch 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEPElasticsearch'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEPElasticsearch'
      name: 'OEPElasticsearch'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEWAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEWAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEWAuditLogs'
      name: 'OEWAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEWExperimentAssignmentSummary 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEWExperimentAssignmentSummary'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEWExperimentAssignmentSummary'
      name: 'OEWExperimentAssignmentSummary'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEWExperimentScorecardMetricPairs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEWExperimentScorecardMetricPairs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEWExperimentScorecardMetricPairs'
      name: 'OEWExperimentScorecardMetricPairs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OEWExperimentScorecards 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OEWExperimentScorecards'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OEWExperimentScorecards'
      name: 'OEWExperimentScorecards'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OGOAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OGOAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OGOAuditLogs'
      name: 'OGOAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OLPSupplyChainEntityOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OLPSupplyChainEntityOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OLPSupplyChainEntityOperations'
      name: 'OLPSupplyChainEntityOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OLPSupplyChainEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OLPSupplyChainEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OLPSupplyChainEvents'
      name: 'OLPSupplyChainEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Operation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Operation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Operation'
      name: 'Operation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OracleCloudDatabase 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OracleCloudDatabase'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OracleCloudDatabase'
      name: 'OracleCloudDatabase'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OTelEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OTelEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OTelEvents'
      name: 'OTelEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OTelLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OTelLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OTelLogs'
      name: 'OTelLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OTelResources 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OTelResources'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OTelResources'
      name: 'OTelResources'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OTelSpans 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OTelSpans'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OTelSpans'
      name: 'OTelSpans'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OTelTraces 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OTelTraces'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OTelTraces'
      name: 'OTelTraces'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_OTelTracesAgent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'OTelTracesAgent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'OTelTracesAgent'
      name: 'OTelTracesAgent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PartnerRiskEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PartnerRiskEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PartnerRiskEvents'
      name: 'PartnerRiskEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PaymentHsmHardwareOperationAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PaymentHsmHardwareOperationAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PaymentHsmHardwareOperationAuditLogs'
      name: 'PaymentHsmHardwareOperationAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Perf 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Perf'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Perf'
      name: 'Perf'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PerfInsightsFindings 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PerfInsightsFindings'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PerfInsightsFindings'
      name: 'PerfInsightsFindings'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PerfInsightsImpactedResources 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PerfInsightsImpactedResources'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PerfInsightsImpactedResources'
      name: 'PerfInsightsImpactedResources'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PerfInsightsRun 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PerfInsightsRun'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PerfInsightsRun'
      name: 'PerfInsightsRun'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PFTitleAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PFTitleAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PFTitleAuditLogs'
      name: 'PFTitleAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLAutovacuumStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLAutovacuumStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLAutovacuumStats'
      name: 'PGSQLAutovacuumStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLDbTransactionsStats 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLDbTransactionsStats'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLDbTransactionsStats'
      name: 'PGSQLDbTransactionsStats'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLPgBouncer 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLPgBouncer'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLPgBouncer'
      name: 'PGSQLPgBouncer'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLPgStatActivitySessions 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLPgStatActivitySessions'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLPgStatActivitySessions'
      name: 'PGSQLPgStatActivitySessions'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLQueryStoreQueryText 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLQueryStoreQueryText'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLQueryStoreQueryText'
      name: 'PGSQLQueryStoreQueryText'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLQueryStoreRuntime 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLQueryStoreRuntime'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLQueryStoreRuntime'
      name: 'PGSQLQueryStoreRuntime'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLQueryStoreWaits 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLQueryStoreWaits'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLQueryStoreWaits'
      name: 'PGSQLQueryStoreWaits'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PGSQLServerLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PGSQLServerLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PGSQLServerLogs'
      name: 'PGSQLServerLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PowerBIDatasetsTenant 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PowerBIDatasetsTenant'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PowerBIDatasetsTenant'
      name: 'PowerBIDatasetsTenant'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PowerBIDatasetsWorkspace 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PowerBIDatasetsWorkspace'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PowerBIDatasetsWorkspace'
      name: 'PowerBIDatasetsWorkspace'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PreAuthenticationDiscoveryLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PreAuthenticationDiscoveryLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PreAuthenticationDiscoveryLogs'
      name: 'PreAuthenticationDiscoveryLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PurviewDataSensitivityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PurviewDataSensitivityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PurviewDataSensitivityLogs'
      name: 'PurviewDataSensitivityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PurviewScanStatusLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PurviewScanStatusLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PurviewScanStatusLogs'
      name: 'PurviewScanStatusLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_PurviewSecurityLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'PurviewSecurityLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'PurviewSecurityLogs'
      name: 'PurviewSecurityLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_QuantumProviderAccountDeviceOperationLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'QuantumProviderAccountDeviceOperationLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'QuantumProviderAccountDeviceOperationLogs'
      name: 'QuantumProviderAccountDeviceOperationLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_QuantumProviderAccountJobAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'QuantumProviderAccountJobAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'QuantumProviderAccountJobAuditLogs'
      name: 'QuantumProviderAccountJobAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_QuantumProviderAccountMessageAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'QuantumProviderAccountMessageAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'QuantumProviderAccountMessageAuditLogs'
      name: 'QuantumProviderAccountMessageAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_QuantumProviderAccountQueueAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'QuantumProviderAccountQueueAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'QuantumProviderAccountQueueAuditLogs'
      name: 'QuantumProviderAccountQueueAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_QuantumProviderAccountTargetAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'QuantumProviderAccountTargetAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'QuantumProviderAccountTargetAuditLogs'
      name: 'QuantumProviderAccountTargetAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_QuantumWorkspaceJobAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'QuantumWorkspaceJobAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'QuantumWorkspaceJobAuditLogs'
      name: 'QuantumWorkspaceJobAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_REDConnectionEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'REDConnectionEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'REDConnectionEvents'
      name: 'REDConnectionEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_RemoteNetworkHealthLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'RemoteNetworkHealthLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'RemoteNetworkHealthLogs'
      name: 'RemoteNetworkHealthLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ResourceManagementPublicAccessLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ResourceManagementPublicAccessLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ResourceManagementPublicAccessLogs'
      name: 'ResourceManagementPublicAccessLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_RetinaNetworkFlowLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'RetinaNetworkFlowLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'RetinaNetworkFlowLogs'
      name: 'RetinaNetworkFlowLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SCCMAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SCCMAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SCCMAssessmentRecommendation'
      name: 'SCCMAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SCGPoolExecutionLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SCGPoolExecutionLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SCGPoolExecutionLog'
      name: 'SCGPoolExecutionLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SCGPoolRequestLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SCGPoolRequestLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SCGPoolRequestLog'
      name: 'SCGPoolRequestLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SCOMAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SCOMAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SCOMAssessmentRecommendation'
      name: 'SCOMAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ServiceFabricOperationalEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ServiceFabricOperationalEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ServiceFabricOperationalEvent'
      name: 'ServiceFabricOperationalEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ServiceFabricReliableActorEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ServiceFabricReliableActorEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ServiceFabricReliableActorEvent'
      name: 'ServiceFabricReliableActorEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ServiceFabricReliableServiceEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ServiceFabricReliableServiceEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ServiceFabricReliableServiceEvent'
      name: 'ServiceFabricReliableServiceEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SfBAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SfBAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SfBAssessmentRecommendation'
      name: 'SfBAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SfBOnlineAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SfBOnlineAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SfBOnlineAssessmentRecommendation'
      name: 'SfBOnlineAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SharePointOnlineAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SharePointOnlineAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SharePointOnlineAssessmentRecommendation'
      name: 'SharePointOnlineAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SignalRServiceDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SignalRServiceDiagnosticLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SignalRServiceDiagnosticLogs'
      name: 'SignalRServiceDiagnosticLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SigninLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SigninLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SigninLogs'
      name: 'SigninLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SPAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SPAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SPAssessmentRecommendation'
      name: 'SPAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SQLAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SQLAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SQLAssessmentRecommendation'
      name: 'SQLAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SQLSecurityAuditEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SQLSecurityAuditEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SQLSecurityAuditEvents'
      name: 'SQLSecurityAuditEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageAntimalwareScanResults 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageAntimalwareScanResults'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageAntimalwareScanResults'
      name: 'StorageAntimalwareScanResults'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageBlobLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageBlobLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageBlobLogs'
      name: 'StorageBlobLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageCacheOperationEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageCacheOperationEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageCacheOperationEvents'
      name: 'StorageCacheOperationEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageCacheUpgradeEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageCacheUpgradeEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageCacheUpgradeEvents'
      name: 'StorageCacheUpgradeEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageCacheWarningEvents 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageCacheWarningEvents'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageCacheWarningEvents'
      name: 'StorageCacheWarningEvents'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageFileLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageFileLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageFileLogs'
      name: 'StorageFileLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageMalwareScanningResults 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageMalwareScanningResults'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageMalwareScanningResults'
      name: 'StorageMalwareScanningResults'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageMoverAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageMoverAuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageMoverAuditLogs'
      name: 'StorageMoverAuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageMoverCopyLogsFailed 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageMoverCopyLogsFailed'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageMoverCopyLogsFailed'
      name: 'StorageMoverCopyLogsFailed'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageMoverCopyLogsTransferred 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageMoverCopyLogsTransferred'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageMoverCopyLogsTransferred'
      name: 'StorageMoverCopyLogsTransferred'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageMoverJobRunLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageMoverJobRunLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageMoverJobRunLogs'
      name: 'StorageMoverJobRunLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageQueueLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageQueueLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageQueueLogs'
      name: 'StorageQueueLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_StorageTableLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'StorageTableLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'StorageTableLogs'
      name: 'StorageTableLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SucceededIngestion 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SucceededIngestion'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SucceededIngestion'
      name: 'SucceededIngestion'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SVMPoolExecutionLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SVMPoolExecutionLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SVMPoolExecutionLog'
      name: 'SVMPoolExecutionLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SVMPoolRequestLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SVMPoolRequestLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SVMPoolRequestLog'
      name: 'SVMPoolRequestLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseBigDataPoolApplicationsEnded 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseBigDataPoolApplicationsEnded'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseBigDataPoolApplicationsEnded'
      name: 'SynapseBigDataPoolApplicationsEnded'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseBuiltinSqlPoolRequestsEnded 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseBuiltinSqlPoolRequestsEnded'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseBuiltinSqlPoolRequestsEnded'
      name: 'SynapseBuiltinSqlPoolRequestsEnded'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseDXCommand 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseDXCommand'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseDXCommand'
      name: 'SynapseDXCommand'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseDXFailedIngestion 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseDXFailedIngestion'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseDXFailedIngestion'
      name: 'SynapseDXFailedIngestion'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseDXIngestionBatching 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseDXIngestionBatching'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseDXIngestionBatching'
      name: 'SynapseDXIngestionBatching'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseDXQuery 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseDXQuery'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseDXQuery'
      name: 'SynapseDXQuery'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseDXSucceededIngestion 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseDXSucceededIngestion'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseDXSucceededIngestion'
      name: 'SynapseDXSucceededIngestion'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseDXTableDetails 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseDXTableDetails'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseDXTableDetails'
      name: 'SynapseDXTableDetails'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseDXTableUsageStatistics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseDXTableUsageStatistics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseDXTableUsageStatistics'
      name: 'SynapseDXTableUsageStatistics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseGatewayApiRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseGatewayApiRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseGatewayApiRequests'
      name: 'SynapseGatewayApiRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseIntegrationActivityRuns 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseIntegrationActivityRuns'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseIntegrationActivityRuns'
      name: 'SynapseIntegrationActivityRuns'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseIntegrationPipelineRuns 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseIntegrationPipelineRuns'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseIntegrationPipelineRuns'
      name: 'SynapseIntegrationPipelineRuns'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseIntegrationTriggerRuns 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseIntegrationTriggerRuns'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseIntegrationTriggerRuns'
      name: 'SynapseIntegrationTriggerRuns'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseLinkEvent 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseLinkEvent'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseLinkEvent'
      name: 'SynapseLinkEvent'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseRbacOperations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseRbacOperations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseRbacOperations'
      name: 'SynapseRbacOperations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseScopePoolScopeJobsEnded 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseScopePoolScopeJobsEnded'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseScopePoolScopeJobsEnded'
      name: 'SynapseScopePoolScopeJobsEnded'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseScopePoolScopeJobsStateChange 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseScopePoolScopeJobsStateChange'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseScopePoolScopeJobsStateChange'
      name: 'SynapseScopePoolScopeJobsStateChange'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseSqlPoolDmsWorkers 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseSqlPoolDmsWorkers'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseSqlPoolDmsWorkers'
      name: 'SynapseSqlPoolDmsWorkers'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseSqlPoolExecRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseSqlPoolExecRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseSqlPoolExecRequests'
      name: 'SynapseSqlPoolExecRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseSqlPoolRequestSteps 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseSqlPoolRequestSteps'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseSqlPoolRequestSteps'
      name: 'SynapseSqlPoolRequestSteps'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseSqlPoolSqlRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseSqlPoolSqlRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseSqlPoolSqlRequests'
      name: 'SynapseSqlPoolSqlRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_SynapseSqlPoolWaits 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'SynapseSqlPoolWaits'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'SynapseSqlPoolWaits'
      name: 'SynapseSqlPoolWaits'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Syslog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Syslog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Syslog'
      name: 'Syslog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_TOUserAudits 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'TOUserAudits'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'TOUserAudits'
      name: 'TOUserAudits'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_TOUserDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'TOUserDiagnostics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'TOUserDiagnostics'
      name: 'TOUserDiagnostics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_TSIIngress 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'TSIIngress'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'TSIIngress'
      name: 'TSIIngress'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCClient 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCClient'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCClient'
      name: 'UCClient'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCClientReadinessStatus 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCClientReadinessStatus'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCClientReadinessStatus'
      name: 'UCClientReadinessStatus'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCClientUpdateStatus 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCClientUpdateStatus'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCClientUpdateStatus'
      name: 'UCClientUpdateStatus'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCDeviceAlert 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCDeviceAlert'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCDeviceAlert'
      name: 'UCDeviceAlert'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCDOAggregatedStatus 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCDOAggregatedStatus'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCDOAggregatedStatus'
      name: 'UCDOAggregatedStatus'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCDOStatus 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCDOStatus'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCDOStatus'
      name: 'UCDOStatus'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCServiceUpdateStatus 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCServiceUpdateStatus'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCServiceUpdateStatus'
      name: 'UCServiceUpdateStatus'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_UCUpdateAlert 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'UCUpdateAlert'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'UCUpdateAlert'
      name: 'UCUpdateAlert'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Usage 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Usage'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 90
    schema: {
      displayName: 'Usage'
      name: 'Usage'
    }
    totalRetentionInDays: 90
  }
}

resource log_bicepdemo_swec_01_VCoreMongoRequests 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'VCoreMongoRequests'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'VCoreMongoRequests'
      name: 'VCoreMongoRequests'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_VIAudit 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'VIAudit'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'VIAudit'
      name: 'VIAudit'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_VIIndexing 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'VIIndexing'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'VIIndexing'
      name: 'VIIndexing'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_VMBoundPort 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'VMBoundPort'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'VMBoundPort'
      name: 'VMBoundPort'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_VMComputer 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'VMComputer'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'VMComputer'
      name: 'VMComputer'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_VMConnection 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'VMConnection'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'VMConnection'
      name: 'VMConnection'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_VMProcess 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'VMProcess'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'VMProcess'
      name: 'VMProcess'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_W3CIISLog 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'W3CIISLog'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'W3CIISLog'
      name: 'W3CIISLog'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WebPubSubConnectivity 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WebPubSubConnectivity'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WebPubSubConnectivity'
      name: 'WebPubSubConnectivity'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WebPubSubHttpRequest 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WebPubSubHttpRequest'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WebPubSubHttpRequest'
      name: 'WebPubSubHttpRequest'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WebPubSubMessaging 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WebPubSubMessaging'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WebPubSubMessaging'
      name: 'WebPubSubMessaging'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Windows365AuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Windows365AuditLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Windows365AuditLogs'
      name: 'Windows365AuditLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Windows365CheckpointLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Windows365CheckpointLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Windows365CheckpointLogs'
      name: 'Windows365CheckpointLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Windows365ConnectionErrorLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Windows365ConnectionErrorLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Windows365ConnectionErrorLogs'
      name: 'Windows365ConnectionErrorLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Windows365ConnectionLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Windows365ConnectionLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Windows365ConnectionLogs'
      name: 'Windows365ConnectionLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_Windows365NetworkLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'Windows365NetworkLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'Windows365NetworkLogs'
      name: 'Windows365NetworkLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WindowsClientAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WindowsClientAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WindowsClientAssessmentRecommendation'
      name: 'WindowsClientAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WindowsServerAssessmentRecommendation 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WindowsServerAssessmentRecommendation'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WindowsServerAssessmentRecommendation'
      name: 'WindowsServerAssessmentRecommendation'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WorkloadDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WorkloadDiagnosticLogs'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WorkloadDiagnosticLogs'
      name: 'WorkloadDiagnosticLogs'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WOUserAudits 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WOUserAudits'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WOUserAudits'
      name: 'WOUserAudits'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WOUserDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WOUserDiagnostics'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WOUserDiagnostics'
      name: 'WOUserDiagnostics'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDAgentHealthStatus 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDAgentHealthStatus'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDAgentHealthStatus'
      name: 'WVDAgentHealthStatus'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDAutoscaleEvaluationPooled 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDAutoscaleEvaluationPooled'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDAutoscaleEvaluationPooled'
      name: 'WVDAutoscaleEvaluationPooled'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDCheckpoints 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDCheckpoints'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDCheckpoints'
      name: 'WVDCheckpoints'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDConnectionGraphicsDataPreview 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDConnectionGraphicsDataPreview'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDConnectionGraphicsDataPreview'
      name: 'WVDConnectionGraphicsDataPreview'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDConnectionNetworkData 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDConnectionNetworkData'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDConnectionNetworkData'
      name: 'WVDConnectionNetworkData'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDConnections 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDConnections'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDConnections'
      name: 'WVDConnections'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDErrors 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDErrors'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDErrors'
      name: 'WVDErrors'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDFeeds 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDFeeds'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDFeeds'
      name: 'WVDFeeds'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDHostRegistrations 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDHostRegistrations'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDHostRegistrations'
      name: 'WVDHostRegistrations'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDManagement 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDManagement'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDManagement'
      name: 'WVDManagement'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDMultiLinkAdd 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDMultiLinkAdd'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDMultiLinkAdd'
      name: 'WVDMultiLinkAdd'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_WVDSessionHostManagement 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'WVDSessionHostManagement'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'WVDSessionHostManagement'
      name: 'WVDSessionHostManagement'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ZTSGraph 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ZTSGraph'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ZTSGraph'
      name: 'ZTSGraph'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ZTSJobStatus 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ZTSJobStatus'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ZTSJobStatus'
      name: 'ZTSJobStatus'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ZTSMetadata 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ZTSMetadata'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ZTSMetadata'
      name: 'ZTSMetadata'
    }
    totalRetentionInDays: 30
  }
}

resource log_bicepdemo_swec_01_ZTSRequest 'Microsoft.OperationalInsights/workspaces/tables@2026-03-01' = {
  parent: log_bicepdemo_swec_01
  name: 'ZTSRequest'
  properties: {
    plan: 'Analytics'
    protectionLevel: 'General'
    retentionInDays: 30
    schema: {
      displayName: 'ZTSRequest'
      name: 'ZTSRequest'
    }
    totalRetentionInDays: 30
  }
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
