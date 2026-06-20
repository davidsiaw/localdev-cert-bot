# Getting Started

## Overview

localdevbot automates wildcard TLS certificate renewal via Let's Encrypt + Cloudflare DNS, with certificates stored securely in **1Password**.

## Prerequisites

- A **Cloudflare account** with a domain managed on Cloudflare
- A **1Password account** with a Service Account (token starting with `ops_`)
- **Docker** and **Docker Compose** (for local testing)
- **Portainer** (for production deployment)

## Quick Start

### 1. Cloudflare API Token

Create a Cloudflare API token with at least these permissions:

- **Zone > DNS > Edit** for your domain

### 2. 1Password Setup

1. Create a vault (or use an existing one, e.g. `Certificates`)
2. Create a **Service Account** and note the token
3. The app will automatically create an item in the vault with three password fields: `crt`, `key`, `chain`

### 3. Deploy to Portainer

1. Create external volumes: `certbot-data`, `certbot-work`, `certbot-logs`
2. Upload `stack-definition.yml`
3. Fill in the environment variables (see [Configuration](configuration.md))
4. Deploy

### 4. Local Testing

```bash
cp .env.example .env
docker compose up --build -d
```

See [Configuration](configuration.md) for all env var options.
