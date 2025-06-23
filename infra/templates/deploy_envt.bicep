param location string = resourceGroup().location
param storageAccountNamePrefix string 
param acr_name string = 'techskoolaracr'
param asb_name string = 'techskoolarasb'
param app_name string = 'techskoolarapp'

var asp_name ='ASP-${app_name}'
var stgacc_name='${storageAccountNamePrefix}${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: stgacc_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
 
}


resource container_registry 'microsoft.containerregistry/registries@2022-02-01-preview' = {
  name: acr_name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    
    }
  }

  resource asb 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
    name: asb_name
    location: location
    
  }

resource asp 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: asp_name
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
}

  resource webapp 'Microsoft.Web/sites@2022-03-01' = {
  name: app_name
  location: location
  tags: null
  properties: {
   
    serverFarmId: asp.id
    clientAffinityEnabled: false
    httpsOnly: true
   
  }
  dependsOn: []
}

