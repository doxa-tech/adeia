require 'factory_bot_rails'
require 'capybara/rspec'
require 'rspec/active_model/mocks'
require 'rails-controller-testing'

FactoryBot.definition_file_paths = [ File.join(File.dirname(__FILE__), '../spec/factories') ]
FactoryBot.find_definitions

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryBot::Syntax::Methods

end
