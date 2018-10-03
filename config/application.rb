require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'en', '*.{rb,yml}').to_s,
      Rails.root.join('config', 'locales', 'cy', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    # config.active_record.schema_format = :sql
    config.autoload_paths += Dir["#{config.root}/app/{services,forms,forms/concerns,presenters,validators}"]

    # Application Title (Populates <title>)
    config.app_title = 'Employment Tribunals'
    # Proposition Title (Populates proposition header)
    config.proposition_title = 'Employment Tribunals'
    # Current Phase (Sets the current phase and the colour of phase tags)
    # Presumed values: alpha, beta, live
    config.phase = 'live'
    # Product Type (Adds class to body based on service type)
    # Presumed values: information, service
    config.product_type = ''
    # Feedback URL (URL for feedback link in phase banner)
    config.feedback_url = ''
    # Controlls how many additional respondents are allowed
    config.additional_respondents_limit = 4

    config.assets.enabled = true

    config.assets.precompile += [
      'application-ie.css',
      'application-ie6.css',
      'application-ie7.css',
      'application-ie8.css',
      '*.png'
    ]

    config.cache_store = :memory_store

    config.action_mailer.default_options = { from: 'no-reply@digital.justice.gov.uk' }

    config.secure_session_cookie = false
    config.exceptions_app = self.routes
  end
end
