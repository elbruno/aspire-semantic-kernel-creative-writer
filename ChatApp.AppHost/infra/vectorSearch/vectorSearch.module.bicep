@description('The location for the resource(s) to be deployed.')
param location string = resourceGroup().location

param principalId string

param principalType string

resource vectorSearch 'Microsoft.Search/searchServices@2023-11-01' = {
  name: take('vectorsearch-${uniqueString(resourceGroup().id)}', 60)
  location: location
  properties: {
    hostingMode: 'default'
    disableLocalAuth: true
    partitionCount: 1
    replicaCount: 1
  }
  sku: {
    name: 'basic'
  }
  tags: {
    'aspire-resource-name': 'vectorSearch'
  }
}

resource vectorSearch_SearchIndexDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(vectorSearch.id, principalId, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8ebe5a00-799e-43f5-93ac-243d3dce84a7'))
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8ebe5a00-799e-43f5-93ac-243d3dce84a7')
    principalType: principalType
  }
  scope: vectorSearch
}

resource vectorSearch_SearchServiceContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(vectorSearch.id, principalId, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7ca78c08-252a-4471-8644-bb5ff32d4ba0'))
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7ca78c08-252a-4471-8644-bb5ff32d4ba0')
    principalType: principalType
  }
  scope: vectorSearch
}

output connectionString string = 'Endpoint=https://${vectorSearch.name}.search.windows.net'