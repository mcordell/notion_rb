# frozen_string_literal: true
require 'single_cov'
SingleCov.setup :rspec

require 'bundler/setup'
require 'notion_rb'
require 'byebug'
require 'factory_bot'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryBot::Syntax::Methods
  FactoryBot.find_definitions
end

NotionRb.configure do |config|
  config[:token_v2] = ENV['TOKEN_V2']
end
