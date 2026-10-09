output "cdn_bucket" {
  value = cloudflare_r2_bucket.cdn.name
}

output "cdn_base_url" {
  value = "https://${cloudflare_r2_custom_domain.cdn.domain}"
}
