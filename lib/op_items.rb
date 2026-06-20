# frozen_string_literal: true

require 'fileutils'

# Op — 1Password item operations
class Op
  # Upload certificate data to an API Credential item in 1Password
  # Fields: crt (fullchain.pem), key (privkey.pem), chain (chain.pem)
  def upload_cert(domain, cert_data)
    item_name = Config.op_item_name(domain)
    template_path = write_template(item_name, cert_data)
    existing = find_item(domain)
    action = existing ? :update : :create
    send(action, item_name, existing, template_path)
    FileUtils.rm_f(template_path)
    puts "Certificate uploaded to 1Password: #{item_name}"
  end

  # List all cert items in the vault
  def list_certs
    vault = Config.op_vault
    result = op_cmd("item list --format json --vault #{vault}")
    items = JSON.parse(result)
    if items.empty?
      puts "No certificates found in vault '#{vault}'"
    else
      items.each do |item|
        puts "  - #{item['title']} (expires: #{item.dig('details', 'expiry') || 'N/A'})"
      end
    end
  end

  private

  def write_template(item_name, cert_data)
    template = { 'title' => item_name, 'fields' => fields(cert_data) }
    path = '/tmp/op-template.json'
    File.write(path, template.to_json)
    path
  end

  def fields(cert_data)
    %i[fullchain privkey chain].map do |field|
      { 'id' => field.to_s, 'type' => 'concealed', 'label' => field.to_s, 'value' => cert_data[field] }
    end
  end

  def update(item_name, existing, template_path)
    puts "Updating existing item: #{item_name} (id: #{existing['id']})"
    op_cmd("item edit #{existing['id']} --template=#{template_path}")
  end

  def create(item_name, _existing, template_path)
    puts "Creating new item: #{item_name}"
    op_cmd("item create --category=API\\ Credential --template=#{template_path}")
  end

  def find_item(domain)
    vault = Config.op_vault
    result = op_cmd("item list --format json --vault #{vault}")
    items = JSON.parse(result)
    item_name = Config.op_item_name(domain)
    items.find { |item| item['title'] == item_name }
  end
end
