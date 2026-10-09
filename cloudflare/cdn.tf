# Public asset CDN: R2 bucket served at cdn.sharosoo.com through the Cloudflare edge.
# Objects carry their own Cache-Control (set by the `cdn` CLI), so no zone cache rules are needed.

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
