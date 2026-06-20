# frozen_string_literal: true

require 'open3'
require 'json'
require_relative 'op_items'

# Op — 1Password CLI integration
class Op
  def initialize
    @token = Config.op_token
    raise '1Password token not set' if @token.nil? || @token.empty?

    @account = Config.op_account
  end

  def op_cmd(*args)
    account_arg = @account ? "--account #{@account}" : ''
    cmd = "OP_SERVICE_ACCOUNT_TOKEN=#{@token} op #{args.join(' ')} #{account_arg} < /dev/null"
    stdout, stderr, status = Open3.capture3(cmd)
    raise "op failed: #{stderr.strip}" unless status.success?

    stdout
  end
end
