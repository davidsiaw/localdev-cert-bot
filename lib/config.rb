# frozen_string_literal: true

# Config — reads all required ENV variables
module Config
  def self.env(key, required: true, default: nil)
    val = ENV[key] || default
    raise "ENV['#{key}'] is required but not set" if required && val.nil?

    val
  end

  def self.cloudflare_api_token
    env('CLOUDFLARE_API_TOKEN')
  end

  def self.domain
    env('DOMAIN')
  end

  def self.op_token
    ENV['OP_SERVICE_ACCOUNT_TOKEN'] || ENV.fetch('OP_TOKEN', nil)
  end

  def self.op_account
    ENV.fetch('OP_ACCOUNT', nil)
  end

  def self.op_vault
    ENV.fetch('OP_VAULT', 'Certificates')
  end

  def self.op_item_name(domain)
    ENV.fetch('OP_ITEM_NAME', "#{domain} wildcard certs")
  end

  def self.email
    env('CERTBOT_EMAIL', required: false, default: "admin@#{domain}")
  end

  def self.agree_tos?
    ENV.fetch('CERTBOT_AGREE', 'true') == 'true'
  end
end
