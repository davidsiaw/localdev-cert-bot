# frozen_string_literal: true

# Certbot — wraps certbot CLI for Cloudflare DNS validation
class Certbot
  CERT_DIR = '/etc/letsencrypt'

  def domain
    Config.domain
  end

  def email
    Config.email
  end

  def cli
    static = %w[
      certbot certonly --non-interactive --agree-tos
      --dns-cloudflare --dns-cloudflare-credentials /tmp/cf.ini
      --dns-cloudflare-propagation-seconds 60
      --work-dir /tmp/certbot-work --logs-dir /tmp/certbot-logs
    ]
    dynamic = ["--email #{email}", "--domain *.#{domain}", "--domain #{domain}"]
    (static + dynamic).join(" \\\n")
  end

  def write_cf_ini
    ini = <<~INI
      dns_cloudflare_api_token = #{Config.cloudflare_api_token}
    INI
    File.write('/tmp/cf.ini', ini)
    File.chmod(0o600, '/tmp/cf.ini')
  end

  def fetch_wildcard
    write_cf_ini

    cmd = if Config.agree_tos?
            cli
          else
            cli.sub("--agree-tos --email #{email} \\n", '')
          end

    puts "Running: #{cmd.gsub('\\n', ' ')}"
    system(cmd) || raise('certbot failed')

    CertStore.new.save(domain)
  end

  def revoke_wildcard
    cert_path = "#{CERT_DIR}/live/#{domain}/fullchain.pem"
    raise "Cert not found at #{cert_path}" unless File.exist?(cert_path)

    system("certbot revoke --cert-path #{cert_path} --non-interactive") ||
      raise('certbot revoke failed')

    puts 'Certificate revoked.'
  end
end
