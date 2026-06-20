# localdevbot — Automated TLS Certificate Manager

Automated wildcard TLS certificate renewal via Let's Encrypt + Cloudflare DNS, with certificates stored securely in **1Password**.

## Quick Start

```bash
cp .env.example .env
docker compose up --build -d
```

## Documentation

| Doc | Description |
|-----|-------------|
| [Getting Started](docs/getting-started.md) | Prerequisites and setup guide |
| [Configuration](docs/configuration.md) | Environment variables reference |
| [Usage](docs/usage.md) | Running the container and CLI operations |
| [Operations](docs/operations.md) | Detailed guide for renew, upload, list, revoke |
| [Architecture](docs/architecture.md) | How it works under the hood |
| [Troubleshooting](docs/troubleshooting.md) | Common issues and fixes |
