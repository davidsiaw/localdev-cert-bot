# Usage

## Portainer Deployment (Production)

Deploy via `stack-definition.yml` in Portainer. The container runs a loop that:

1. Checks if the wildcard certificate needs renewal
2. Fetches a new cert via certbot + Cloudflare DNS if needed
3. Uploads it to 1Password
4. Waits 1 hour, then repeats

The container runs forever with `restart: unless-stopped`.

## Local Testing

```bash
cp .env.example .env
docker compose up --build -d
```

### View logs

```bash
# Follow logs in real-time
docker compose logs -f certbot

# View last 100 lines
docker compose logs --tail=100 certbot
```

## Manual Operations

Run individual operations by overriding the container command:

```bash
docker compose run --rm certbot <operation>
```

See [Operations](operations.md) for details on each command.
