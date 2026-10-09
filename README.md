# infra

Terraform for sharosoo's infrastructure.

## Stacks

|Stack|Manages|
|---|---|
|`cloudflare/`|R2 bucket `sharosoo-cdn`, custom domain `cdn.sharosoo.com`, CORS, edge cache rule|

## Usage

```sh
export CLOUDFLARE_API_TOKEN=...
terraform -chdir=cloudflare init
terraform -chdir=cloudflare plan
terraform -chdir=cloudflare apply
```

Token permissions (custom token, scoped to the sharosoo account and the `sharosoo.com` zone):

|Scope|Permission|
|---|---|
|Account|Workers R2 Storage: Edit|
|Zone|Zone: Read|
|Zone|DNS: Edit|
|Zone|Cache Rules: Edit|

## CDN

- `https://cdn.sharosoo.com/<key>` serves bucket `sharosoo-cdn`.
- Edge TTL is one year (cache rule). Browser TTL comes from each object's `Cache-Control`.
- Upload with [`sharosoo-cdn`](https://github.com/sharosoo/sharosoo-cdn); it sets headers and purges the edge on overwrite and delete.
- CORS: `GET`/`HEAD` from any origin.

## State

`cloudflare/terraform.tfstate` is committed. It holds no secrets; keep it that way, or move to a remote backend before adding resources that store secrets.
