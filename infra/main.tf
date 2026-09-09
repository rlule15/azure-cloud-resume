// local variables available for the current scope
locals {
  project = "cloud-resume-challenge"
  env     = "dev"
  region  = "mxct"
}

// Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-crc-${local.env}-${local.region}"
  location = "Mexico Central"
}

// Create a storage account
resource "azurerm_storage_account" "resume" {
  name                     = "stcrc${local.env}${local.region}01"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.env
    Project     = local.project
  }
}

// Enable static website hosting on the storage account
resource "azurerm_storage_account_static_website" "resume" {
  storage_account_id = azurerm_storage_account.resume.id
  error_404_document = "404.html"
  index_document     = "index.html"
}
