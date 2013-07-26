# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'rails/application'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'
#require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

FakeWeb.allow_net_connect = true

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.order = 'rand'
  config.include FactoryGirl::Syntax::Methods
  config.include FrenzyHelpers, type: :feature

  require 'database_cleaner'
  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    FakeWeb.clean_registry
  end

  config.after do
    DatabaseCleaner.clean
  end
end
