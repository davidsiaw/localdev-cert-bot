# Architecture

## Data Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Ruby App   │────>│    Certbot   │────>│   Cloudflare │
│ (certbot_    │     │ (DNS-01      │     │  DNS API     │
│  cloudflare  │     │  challenge)  │     │              │
│  .rb)        │<────│              │<────│              │
└──────┬───────┘     └──────────────┘     └──────────────┘
       │
       │ reads cert files
       ▼
┌──────────────┐     ┌──────────────┐
│  CertStore   │────>│   1Password  │
└──────────────┘     │   (crt, key, │
                     │    chain)    │
                     └──────────────┘
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/certbot_cloudflare.rb` | Main entry point — handles renew, upload, list, revoke |
| `lib/config.rb` | Reads all ENV variables (module namespace) |
| `lib/certbot.rb` | Wraps certbot CLI with Cloudflare DNS-01 |
| `lib/op.rb` | 1Password CLI integration (op_cmd helper) |
| `lib/op_items.rb` | 1Password item operations (upload, find, list) |
| `lib/cert_store.rb` | Reads cert files from `/etc/letsencrypt` |

## Design Decisions

- **Instance methods** — All behavior classes use instance methods, instantiated at the CLI bottom
- **No config in instance vars** — Config values accessed via methods (`domain`, `email`) not stored in `@vars`
- **Static/dynamic CLI split** — certbot CLI args separated into static and dynamic arrays, joined at runtime

## Container Structure

The Docker image is built in two stages:

1. **Stage 1** — Pull the 1Password CLI binary from `1password/op:2`
2. **Stage 2** — Base `ruby:3.3-slim`, install Python/pip, install certbot + Cloudflare plugin, copy 1Password CLI

## Volume Layout

| Volume | Mount Path | Contents |
|--------|-----------|----------|
| `certbot-data` | `/etc/letsencrypt` | Certificates, config, state |
| `certbot-work` | `/tmp/certbot-work` | Certbot working directory |
| `certbot-logs` | `/tmp/certbot-logs` | Certbot logs |
