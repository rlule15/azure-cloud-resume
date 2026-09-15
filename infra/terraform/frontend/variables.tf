variable "domain_name" {
  type        = string
  description = "The custom domain name for the static web app."
  sensitive   = false
}

variable "cloudflare_api_token" {
  type        = string
  description = "The API token for Cloudflare."
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone ID for the domain."
  sensitive   = true
}
