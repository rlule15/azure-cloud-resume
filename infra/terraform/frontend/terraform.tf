terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev-ctus"
    storage_account_name = "statftstatedevctus"
    container_name       = "tfstate"
    key                  = "frontend/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

