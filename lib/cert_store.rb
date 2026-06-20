# frozen_string_literal: true

require 'openssl'

# CertStore — reads cert files from certbot's local storage
class CertStore
  CERT_DIR = '/etc/letsencrypt'
  RENEW_THRESHOLD_DAYS = 30

  def cert_path(domain, file)
    "#{CERT_DIR}/live/#{domain}/#{file}.pem"
  end

  def save(domain)
    cert_data = load(domain)
    puts 'Certificate files:'
    puts "  fullchain: #{cert_path(domain, 'fullchain')}"
    puts "  privkey:   #{cert_path(domain, 'privkey')}"
    puts "  chain:     #{cert_path(domain, 'chain')}"
    cert_data
  end

  def load(domain)
    {
      fullchain: File.read(cert_path(domain, 'fullchain')).strip,
      privkey: File.read(cert_path(domain, 'privkey')).strip,
      chain: File.read(cert_path(domain, 'chain')).strip,
      csr: (File.read(cert_path(domain, 'csr')).strip if File.exist?(cert_path(domain, 'csr'))),
    }
  rescue Errno::ENOENT => e
    raise "Cert files not found for #{domain}: #{e.message}"
  end

  def days_until_expiry(domain)
    cert = OpenSSL::X509::Certificate.new(File.read(cert_path(domain, 'fullchain')))
    (cert.not_after.to_i - Time.now.to_i) / 86_400
  end

  def needs_renewal?(domain)
    return false unless File.exist?(cert_path(domain, 'fullchain'))

    days_until_expiry(domain) <= RENEW_THRESHOLD_DAYS
  end
end
