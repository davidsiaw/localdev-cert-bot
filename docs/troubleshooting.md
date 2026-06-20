# Troubleshooting

## Certificate not found after renew

Check that certbot ran successfully:

```bash
docker compose logs certbot | grep -i certbot
```

Verify the cert files exist inside the container:

```bash
docker exec certbot-cloudflare ls -la /etc/letsencrypt/live/<domain>/
```

## 1Password upload fails

- Confirm the Service Account token is valid and has access to the vault
- Check that the vault name (`OP_VAULT`) matches your vault
- Verify the 1Password CLI is accessible:

```bash
docker exec certbot-cloudflare op --version
```

## Rate limited by Let's Encrypt

Use staging mode to avoid rate limits during testing:

```yaml
# stack-definition.yml
LE_STAGING: 'true'
```

Staging certificates are not trusted by browsers — only use for testing.

## Container won't start

Check the build logs:

```bash
docker compose build certbot
```

Check container logs for errors:

```bash
docker compose logs certbot
```

## Portainer deployment issues

- Make sure external volumes (`certbot-data`, `certbot-work`, `certbot-logs`) are created before deploying
- Verify all environment variables are filled in the Portainer UI
- Check the container logs after deployment:

```bash
docker logs certbot-cloudflare
```
