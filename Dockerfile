# Stage 1: Get the 1Password CLI binary
FROM 1password/op:2 AS op

# Stage 2: Main image
FROM ruby:3.3-slim

# Install certbot and its Cloudflare plugin
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    build-essential \
    && pip3 install --break-system-packages certbot certbot-dns-cloudflare \
    && rm -rf /var/lib/apt/lists/*

# Copy 1Password CLI from stage 1
COPY --from=op /usr/local/bin/op /usr/local/bin/op

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --no-cache --without development

COPY lib/ lib/
