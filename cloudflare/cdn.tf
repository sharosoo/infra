# Public asset CDN: R2 bucket served at cdn.sharosoo.com through the Cloudflare edge.

resource "cloudflare_r2_bucket" "cdn" {
  account_id = var.account_id
  name       = "sharosoo-cdn"
  location   = "apac"
}

resource "cloudflare_r2_custom_domain" "cdn" {
  account_id  = var.account_id
  bucket_name = cloudflare_r2_bucket.cdn.name
  domain      = "cdn.sharosoo.com"
  zone_id     = var.zone_id
  enabled     = true
  min_tls     = "1.2"
}

# Read-only cross-origin access so pages on any origin can fetch images, fonts and JSON via fetch()/canvas.
resource "cloudflare_r2_bucket_cors" "cdn" {
  account_id  = var.account_id
  bucket_name = cloudflare_r2_bucket.cdn.name

  rules = [{
    id = "public-read"
    allowed = {
      methods = ["GET", "HEAD"]
      origins = ["*"]
    }
    max_age_seconds = 86400
  }]
}

# Edge keeps objects for a year regardless of the browser TTL in each object's Cache-Control.
# The `sharosoo-cdn` CLI purges a URL whenever it overwrites or deletes the object behind it.
resource "cloudflare_ruleset" "cache" {
  zone_id = var.zone_id
  name    = "default"
  kind    = "zone"
  phase   = "http_request_cache_settings"

  rules = [{
    description = "cdn.sharosoo.com: 1 year edge TTL"
    expression  = "(http.host eq \"cdn.sharosoo.com\")"
    action      = "set_cache_settings"
    action_parameters = {
      cache = true
      edge_ttl = {
        mode    = "override_origin"
        default = 31536000
      }
      browser_ttl = {
        mode = "respect_origin"
      }
    }
    enabled = true
  }]
}
