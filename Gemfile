source 'https://rubygems.org'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.4.2'
gem 'responders', '~> 3.0'

# Azure deployment so we need this
gem 'azure_env_secrets', git: 'https://github.com/ministryofjustice/azure_env_secrets.git', tag: 'v0.1.3'
gem 'et_azure_insights', '0.3.2', git: 'https://github.com/hmcts/et-azure-insights.git', tag: 'v0.3.2'
#gem 'et_azure_insights', path: '../../../et_azure_insights'
gem 'application_insights', git: 'https://github.com/microsoft/ApplicationInsights-Ruby.git', ref: '5db6b4'

# Use SCSS for stylesheets
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.2'

# Use iodine as the app server
gem 'iodine', '~> 0.7'

# Use null db adapter for the form objects
gem 'activerecord-nulldb-adapter', '~> 0.8'

# Use dotenv for convenience in all environments
gem 'dotenv-rails', '~> 2.7'

# Gov uk notify service
gem 'notifications-ruby-client', '~> 5.3'
gem 'govuk_notify_rails', git: 'https://github.com/hmcts/govuk_notify_rails.git', tag: 'v3.0.0'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

group :development, :test do
  gem 'awesome_print', '~> 1.9'
  gem 'better_errors', '~> 2.9'
  gem 'binding_of_caller', '~> 1.0'
  gem 'brakeman', '~> 5.1', '>= 5.1.1'
  gem 'capybara', '~> 3.34'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'gov_fake_notify', '~> 1.1', '>= 1.1.1'
  gem 'launchy'
  gem 'listen', '~> 3.7'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-its', '~> 1.2', require: 'rspec/its'
  gem 'rspec-rails', '~> 6.0'
  gem 'rubocop', '~> 1.8', :require => false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', '~> 2.1', :require => false
  gem 'shoulda-matchers', '~> 5.1'
  gem 'spring', '~> 4.0'
  gem 'parallel_tests', '~> 4.0'
  gem 'simplecov', '~> 0.21'
  gem 'webdrivers', '~> 5.0'
  gem 'webrick', '~> 1.4', '>= 1.4.2'
  gem 'ruby-debug-ide'
  gem 'debase'
  gem 'solargraph'
end

group :test do
  gem 'cuprite', '~> 0.10'
  gem 'webmock', '~> 3.11'
  gem 'database_cleaner', '~> 2.0'
  gem 'poltergeist', '~> 1.18'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'site_prism', '~> 3.7'
  gem 'selenium-webdriver', '~> 4.3'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'climate_control', '~> 1.0'
  gem 'puma', '~> 5.1'
  gem 'et_test_helpers', git: 'https://github.com/hmcts/et_test_helpers.git', tag: 'v1.3.2'
end

group :assets do
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '~> 4.1'
end

group :production, :test, :development do
  gem "sentry-ruby", "~> 5.7"
  gem "sentry-rails", "~> 5.7"
  gem "sentry-sidekiq", "~> 5.7"
end

gem 'activeadmin', '~> 2.9'
gem 'base32_pure', '~> 0.1'
gem 'bcrypt', '~> 3.1'
gem 'bitmask_attributes', '~> 1.0'


gem 'pg', '~> 1.1'
gem 'redcarpet', '~> 3.5'
gem 'slim-rails', '~> 3.2'
gem 'sidekiq', '< 7'
gem 'sidekiq-failures', '~> 1.0'
gem 'sidekiq_alive', '~> 2.1'
gem 'uk_postcode', '~> 2.1'
gem 'email_validator', '~> 2.2'
gem 'typhoeus', '~> 1.4'
gem 'invisible_captcha', '~> 2.0'
gem 'et_gds_design_system', git:'https://github.com/hmcts/et_gds_design_system.git', branch: 'RST-5296'

gem "webpacker", "~> 5.4"
gem "devise", "~> 4.8"
