# infra

Personal infrastructure for `sharosoo.com`, managed as code.

## Stacks

|Stack|Provider|Manages|
|---|---|---|
|`cloudflare/`|Cloudflare (account `93b84e89…`, zone `sharosoo.com`)|R2 bucket `sharosoo-cdn`, custom domain `cdn.sharosoo.com`, bucket CORS|

Not managed here (yet): `arthub-assets` bucket and `artifact.sharosoo.com` (owned by the `artifact-hub` repo), DNS records outside R2 custom domains.

## CDN

`https://cdn.sharosoo.com/<key>` serves objects of R2 bucket `sharosoo-cdn` through the Cloudflare edge.

- Uploads: use the [`cdn`](https://github.com/sharosoo/cdn) CLI, not raw API calls. It sets `Content-Type` and `Cache-Control` and refuses to overwrite published keys.
- Caching: objects carry `Cache-Control: public, max-age=31536000, immutable` by default. Changing a published file means uploading under a new key; overwriting serves stale bytes from caches.
- CORS: `GET`/`HEAD` from any origin.
- Key layout: `<topic>/<file>`, e.g. `goa2/board.png`. Keys from the former `sharosoo/image` GitHub repo kept their paths.

## Running Terraform

```sh
scripts/tf cloudflare plan
scripts/tf cloudflare apply
```

`scripts/tf` uses `CLOUDFLARE_API_TOKEN` if set, otherwise the wrangler OAuth login (`bunx wrangler login`, refreshed automatically). The OAuth login cannot read or edit DNS records; resources that need `dns:edit` or `cache_purge` require a scoped API token in `CLOUDFLARE_API_TOKEN`.

## State

`cloudflare/terraform.tfstate` is committed. The repository is private and the managed resources hold no secrets. Move it to an R2 S3 backend once an R2 access key exists; check the state for secrets before adding resources that have them (API tokens, Workers secrets).
