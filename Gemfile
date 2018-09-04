source 'https://rubygems.org'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.6'
gem 'responders', '~> 2.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.2'

# Use unicorn as the app server
gem 'unicorn', '~> 5.4'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

group :development, :test do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capybara', '~> 2.18'
  gem 'codeclimate-test-reporter', require: nil
  gem 'dotenv-rails', '0.11.1'
  gem 'factory_girl_rails'
  gem 'guard-livereload'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rack-livereload'
  gem 'rspec-its', '~> 1.2', require: 'rspec/its'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', :require => false
  gem 'rubocop-rspec', :require => false
  gem 'shoulda-matchers', '~> 2.7'
  gem 'spring', '~> 2.0'
  gem 'activerecord-nulldb-adapter', '~> 0.3'
  gem 'parallel_tests', '~> 2.22'
end

group :test do
  gem 'webmock', '1.20.4'
  gem 'database_cleaner', '~> 1.7'
  gem 'cucumber-rails', '~> 1.6', require: false
  gem 'poltergeist', '1.18'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'site_prism', '~> 2.9'
  gem 'selenium-webdriver', '~> 3.4'
  gem 'rails-controller-testing', '~> 1.0'
end

group :production do
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '3.0.0'
end

group :production, :test do
  gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"
end

gem 'activeadmin', '~> 1.3'
gem 'base32_pure', '~> 0.1'
gem 'bcrypt', '~> 3.1'
gem 'bitmask_attributes', '~> 1.0'
gem 'browserify-rails', '~> 4.3'
gem 'carrierwave', '~> 1.2'
gem 'cocaine', '~> 0.6'
gem 'epdq', github: 'ministryofjustice/epdq'
gem 'fog-aws', '~> 3.0'
gem 'govuk_frontend_toolkit', '~> 4.0.0'
gem 'httparty', '~> 0.16'
gem 'httpx'
gem 'moj_template', '0.23.0'
gem 'pdf-forms', '~> 1.1'
gem 'pg', '~> 1.1'
gem 'redcarpet', '3.4'
gem 'representable', '2.3.0', require: 'representable/xml'
gem 'simple_form', '~> 4.0'
gem 'slim-rails', '~> 3.1'
gem 'sidekiq', '~> 4.2.0'
gem 'state_machine', require: 'state_machine/core'
gem 'uk_postcode'
gem 'susy'
gem 'compass'
gem 'virtus'
gem 'zendesk_api'
gem 'email_validator'
gem 'logstasher', groups: [:production, :local]

# This gem ensures rails 4 also builds a non-digest version of the assets
# so that static pages can refer to them.
gem "non-stupid-digest-assets"
