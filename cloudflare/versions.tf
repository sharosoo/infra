terraform {
  required_version = ">= 1.6"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.27"
    }
  }
}

# Token comes from CLOUDFLARE_API_TOKEN; scripts/tf sets it.
provider "cloudflare" {}
