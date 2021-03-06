# frozen_string_literal: true
require 'mechanize'
require 'json'

require 'notion_rb/version'

require 'notion_rb/api/base'
require 'notion_rb/api/create'
require 'notion_rb/api/destroy'
require 'notion_rb/api/get'
require 'notion_rb/api/query_collection'
require 'notion_rb/api/restore'
require 'notion_rb/api/update'

require 'notion_rb/utils/block_cache'
require 'notion_rb/utils/types'
require 'notion_rb/utils/converter'
require 'notion_rb/utils/parser'
require 'notion_rb/utils/uuid_validator'

require 'notion_rb/block'

require 'notion_rb/transaction'
require 'notion_rb/operations/commands/factory'
require 'notion_rb/operations/factory'

require 'notion_rb/request_params'

module NotionRb
  def self.config
    @config ||= {}
  end

  def self.configure
    yield(config)
  end
end
