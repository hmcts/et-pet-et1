source 'https://rubygems.org'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0'
gem 'responders', '~> 2.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.3'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use unicorn as the app server
gem 'unicorn'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

group :development, :test do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capybara', '~> 2.15'
  gem 'codeclimate-test-reporter', require: nil
  gem 'dotenv-rails', '0.11.1'
  gem 'factory_girl_rails'
  gem 'guard-livereload'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rack-livereload'
  gem 'rspec-its', require: 'rspec/its'
  gem 'rspec-rails', '~> 3.6'
  gem 'rubocop', :require => false
  gem 'rubocop-rspec', :require => false
  gem 'shoulda-matchers'
  gem 'spring'
  gem 'activerecord-nulldb-adapter'
  gem 'parallel_tests', '~> 2.17'
end

group :test do
  gem 'webmock'
  gem 'database_cleaner'
  gem 'cucumber-rails', '~> 1.5', require: false
  gem 'poltergeist', '1.15.0'
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

gem 'activeadmin', '~> 1.0'
gem 'base32_pure'
gem 'bcrypt'
gem 'bitmask_attributes'
gem 'browserify-rails'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave', ref: '56873b07105396e0f1cfdd5e38be930dc3dcd362'
gem 'cocaine'
gem 'epdq', github: 'ministryofjustice/epdq'
gem 'fog-aws'
gem 'govuk_frontend_toolkit', '~> 4.0.0'
gem 'httparty'
gem 'httpx'
gem 'moj_template', '0.23.0'
gem 'pdf-forms'
gem 'pg'
gem 'redcarpet', '3.4.0'
gem 'representable', '2.3.0', require: 'representable/xml'
gem 'simple_form', '~> 3.5'
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