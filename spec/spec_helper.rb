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

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.order = 'rand'
  config.include FactoryGirl::Syntax::Methods
  config.include FrenzyHelpers, type: :feature

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all) do
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end

end
