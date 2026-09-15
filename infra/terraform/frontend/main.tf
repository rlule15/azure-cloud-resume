// local variables available for the current scope
locals {
  project = "cloud-resume-challenge"
  env     = "dev"
  region  = "ctus"
}


// Get the already exsisting resource group
data "azurerm_resource_group" "main" {
  name = "rg-crc-${local.env}-${local.region}"
}

// Create static web app
resource "azurerm_static_web_app" "resume" {
  name                = "swa-crc-${local.env}-${local.region}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku_tier            = "Free"
  sku_size            = "Free"
}

// Create a cloudflare record for the static web app
resource "cloudflare_dns_record" "api_cname" {
  zone_id = var.cloudflare_zone_id
  name    = "api"
  content = azurerm_static_web_app.resume.default_host_name
  type    = "CNAME"
  proxied = false
  ttl     = 300
}

// Wait for DNS propagation before linking the custom domain
resource "time_sleep" "wait_for_dns" {
  depends_on      = [cloudflare_dns_record.api_cname]
  create_duration = "45s"
}

// Link custom domain to static web app
resource "azurerm_static_web_app_custom_domain" "resume" {
  static_web_app_id = azurerm_static_web_app.resume.id
  domain_name       = var.domain_name
  validation_type   = "cname-delegation"

  depends_on = [
    time_sleep.wait_for_dns
  ]
}
