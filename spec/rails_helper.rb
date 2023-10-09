# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require 'rspec/rails'
require 'shoulda/matchers'
require 'database_cleaner'
require 'simplecov'
require "simplecov_json_formatter"
ENV['RAILS_ENV'] ||= 'test'
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start if ENV.fetch('ENABLE_COVERAGE', 'false').downcase == 'true'
require File.expand_path("../../config/environment", __FILE__)


# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # ===
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    I18n.locale = :en
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, :clean_with_truncation => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    travel_back
  end
  # ===

  config.infer_spec_type_from_file_location!

  config.include ActiveSupport::Testing::TimeHelpers

  config.after do |example|
    if example.metadata[:type] == :feature && example.exception.present?
      # Uncomment to autoload failed capybara tests in the browser
      # save_and_open_page
    end
  end
end
