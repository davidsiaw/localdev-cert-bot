# Operations

The app supports four operations via CLI:

```bash
docker compose run --rm certbot <operation>
```

## renew

Request a new wildcard certificate from Let's Encrypt and upload it to 1Password.

```bash
docker compose run --rm certbot renew
```

This is the default operation — it runs automatically every hour in the container loop.

**What it does:**
1. Writes Cloudflare credentials to `/tmp/cf.ini`
2. Runs `certbot certonly --dns-cloudflare` for `*.domain` + `domain`
3. Reads the resulting cert files from `/etc/letsencrypt/live/<domain>/`
4. Uploads them to 1Password

**Note:** Certbot only actually fetches a new cert when it's within 30 days of expiration. If no renewal is needed, it exits immediately.

## upload

Upload existing certificates from `/etc/letsencrypt` to 1Password without re-fetching.

```bash
docker compose run --rm certbot upload
```

Useful if certs were obtained outside this tool and you want to import them.

## list

List all certificate items stored in 1Password.

```bash
docker compose run --rm certbot list
```

Output format:
```
=== Certificates in 1Password ===
  - example.com wildcard certs (expires: 2026-09-18)
=== Done ===
```

## revoke

Revoke existing certificates via Let's Encrypt.

```bash
docker compose run --rm certbot revoke
```

This revokes the cert at `/etc/letsencrypt/live/<domain>/fullchain.pem` and removes it from Let's Encrypt's database.
