# frozen_string_literal: true

require 'pry'
require 'simplecov'
require 'support/cli_spec_behavior'
require 'support/command_line_args_helper'
require 'support/config_yaml_helper'

# SimpleCovのロード処理（RSpecのファイルは除外する）
SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
