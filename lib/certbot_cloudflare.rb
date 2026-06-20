#!/usr/bin/env ruby
# frozen_string_literal: true

# certbot_cloudflare.rb — Main entry point
#
# Operations (first positional arg):
#   renew   - Request/renew wildcard certificates (default)
#   upload  - Upload existing certs from /etc/letsencrypt to 1Password
#   list    - List cert domains known in 1Password
#   revoke  - Revoke existing certificates

require_relative 'config'
require_relative 'certbot'
require_relative 'op'
require_relative 'cert_store'

# Main entry point for certbot + Cloudflare DNS + 1Password integration
class CertbotCloudflare
  def domain
    Config.domain
  end

  def run(operation)
    dispatch(operation)
  end

  private

  def dispatch(operation)
    case operation
    when 'renew' then fetch_and_upload
    when 'upload' then upload_existing
    when 'list' then list_certs_in_1password
    when 'revoke' then revoke_certs
    else
      puts "Unknown operation: #{operation}"
      puts 'Usage: ruby certbot_cloudflare.rb [renew|upload|list|revoke]'
      exit 1
    end
  end

  def fetch_and_upload
    cert_data = fetch_or_renew
    puts '=== Uploading to 1Password ==='
    Op.new.upload_cert(domain, cert_data)
    puts '=== Done ==='
  end

  def fetch_or_renew
    if File.exist?(CertStore.new.cert_path(domain, 'fullchain'))
      cert_data = CertStore.new.load(domain)
      fetch_if_needed(domain, cert_data)
    else
      puts "=== Fetching wildcard certificate for *.#{domain} ==="
      Certbot.new.fetch_wildcard
    end
  end

  def fetch_if_needed(domain, cert_data)
    if CertStore.new.needs_renewal?(domain)
      puts "=== Fetching wildcard certificate for *.#{domain} ==="
      Certbot.new.fetch_wildcard
    else
      days = CertStore.new.days_until_expiry(domain)
      puts "=== Certificate valid for #{days} more days, skipping renewal ==="
      cert_data
    end
  end

  def upload_existing
    puts '=== Uploading existing certs to 1Password ==='
    cert_data = CertStore.new.load(domain)
    Op.new.upload_cert(domain, cert_data)
    puts '=== Done ==='
  end

  def list_certs_in_1password
    puts '=== Certificates in 1Password ==='
    Op.new.list_certs
    puts '=== Done ==='
  end

  def revoke_certs
    puts "=== Revoking certificates for *.#{domain} ==="
    Certbot.new.revoke_wildcard
    puts '=== Done ==='
  end
end

# --- CLI ---
operation = ARGV[0] || 'renew'
CertbotCloudflare.new.run(operation)
