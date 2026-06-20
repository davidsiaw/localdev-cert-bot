# Configuration

All configuration is done via environment variables.

## Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token with **DNS edit** permission | `cfut_xxxxx...` |
| `DOMAIN` | Your domain | `example.com` |
| `OP_SERVICE_ACCOUNT_TOKEN` | 1Password Service Account token | `ops_xxxxx...` |

## Optional Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CERTBOT_EMAIL` | `admin@<domain>` | Contact email for Let's Encrypt |
| `CERTBOT_AGREE` | `true` | Agree to Let's Encrypt Terms of Service |
| `LE_STAGING` | `false` | Use Let's Encrypt staging (higher rate limits, test certs) |
| `OP_VAULT` | `Certificates` | 1Password vault name |
| `OP_ITEM_NAME` | `<domain> wildcard certs` | Item name pattern in 1Password |
| `OP_ACCOUNT` | auto-detected | 1Password account slug |

## Environment File

You can set variables in two ways:

1. **In Portainer** — fill them in the stack definition UI
2. **In a `.env` file** — Docker Compose will automatically load it for local testing

## Let's Encrypt Staging Mode

When testing, enable staging to avoid hitting production rate limits:

```yaml
# stack-definition.yml
environment:
  LE_STAGING: 'true'
```

Staging certificates are not trusted by browsers — only use for testing.
