require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.active_record.schema_format = :sql
    config.autoload_paths += Dir["#{config.root}/app/{services,forms,presenters,validators}"]

    # Application Title (Populates <title>)
    config.app_title = 'Employment Tribunals'
    # Proposition Title (Populates proposition header)
    config.proposition_title = 'Employment Tribunals'
    # Current Phase (Sets the current phase and the colour of phase tags)
    # Presumed values: alpha, beta, live
    config.phase = 'beta'
    # Product Type (Adds class to body based on service type)
    # Presumed values: information, service
    config.product_type = ''
    # Feedback URL (URL for feedback link in phase banner)
    config.feedback_url = ''

    config.assets.enabled = true

    config.assets.precompile += %w(
      application-ie.css
      application-ie6.css
      application-ie7.css
      application-ie8.css
      *.png
    )

    # opt into features that will be the default in the next version of Rails
    # (and supress the DEPRECATION warnings)
    config.active_record.raise_in_transactional_callbacks = true

    config.action_mailer.default_options = { from: 'no-reply@digital.justice.gov.uk' }
  end
end
