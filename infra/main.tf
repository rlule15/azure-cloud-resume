// local variables available for the current scope
locals {
  project = "cloud-resume-challenge"
  env     = "dev"
  region  = "eus"
}

// Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-crc-${local.env}-${local.region}"
  location = "East US"
}

// Create static web app
resource "azurerm_static_web_app" "resume" {
  name                = "swa-crc-${local.env}-${local.region}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_tier            = "Free"
  sku_size            = "Free"
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

// Create cosmos db account
resource "azurerm_cosmosdb_account" "resume_db" {
  name                = "cosmos-crc-${local.env}-${local.region}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
}

// Create cosmos db sql database
resource "azurerm_cosmosdb_sql_database" "resume_db" {
  name                = "db-crc-${local.env}-${local.region}"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.resume_db.name
}

// Create cosmos db sql container (table)
resource "azurerm_cosmosdb_sql_container" "resume_db" {
  name                = "visitors"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.resume_db.name
  database_name       = azurerm_cosmosdb_sql_database.resume_db.name
  partition_key_paths = ["/id"]
}

// Create service plan for az functions
resource "azurerm_service_plan" "function_app" {
  name                = "sp-crc-${local.env}-${local.region}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

// Create the function app
resource "azurerm_linux_function_app" "function_app" {
  name                = "fa-crc-${local.env}-${local.region}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.function_app.id

  storage_account_name       = azurerm_storage_account.resume.name
  storage_account_access_key = azurerm_storage_account.resume.primary_access_key

  site_config {
    application_stack {
      python_version = "3.14"
    }

    cors {
      allowed_origins = ["https://${azurerm_static_web_app.resume.default_host_name}"]
    }
  }


}
