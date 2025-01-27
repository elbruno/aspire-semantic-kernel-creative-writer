param location string = resourceGroup().location
param keyVaultName string

resource bingSearchService 'Microsoft.Bing/accounts@2020-06-10' = {
  name: 'bing-search-${uniqueString(resourceGroup().id)}'
  location: 'global'
  sku: {
    name: 'S1'
  }
  kind: 'Bing.Search.v7'
}

var primaryKey = bingSearchService.listKeys().key1

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName

  resource secret 'secrets@2023-07-01' = {
    name: 'bingAPIKey'
    properties: {
      value: primaryKey
    }
  }
}
