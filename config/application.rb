require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    config.active_support.cache_format_version = 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.config.active_support.cache_format_version = 7.1
    #
    config.time_zone = 'London'
    # config.eager_load_paths << Rails.root.join("extras")

    # The default locale is :en and all translations from config/locales/**/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]
    config.i18n.default_locale = :en
    # config.active_record.schema_format = :sql
    config.active_record.yaml_column_permitted_classes = [ActiveSupport::HashWithIndifferentAccess]
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

    config.cache_store = :memory_store

    config.action_mailer.default_options = { from: ENV.fetch('SMTP_FROM',
                                                             'no-reply@employmenttribunals.service.gov.uk') }
    config.secure_cookies = false
    config.exceptions_app = routes

    config.redis_host = ENV.fetch('REDIS_HOST', 'localhost')
    config.redis_port = ENV.fetch('REDIS_PORT', '6379')
    config.redis_database = ENV.fetch('REDIS_DATABASE', '5')
    default_redis_url = "redis://#{config.redis_host}:#{config.redis_port}"
    config.redis_url = ENV.fetch('REDIS_URL', default_redis_url) + "/#{config.redis_database}"

    role_suffix = Sidekiq.server? ? '-SIDEKIQ' : ''
    insights_key = ENV.fetch('AZURE_APP_INSIGHTS_KEY', false)
    if insights_key
      config.azure_insights.enable = true
      config.azure_insights.key = insights_key
      config.azure_insights.role_name = ENV.fetch('AZURE_APP_INSIGHTS_ROLE_NAME', 'et1') + role_suffix
      config.azure_insights.role_instance = ENV.fetch('HOSTNAME', 'all')
      config.azure_insights.buffer_size = 500
      config.azure_insights.send_interval = 60
    else
      config.azure_insights.enable = false
    end
    config.x.cookie_expiry = 1.year

    config.govuk_notify = ActiveSupport::OrderedOptions.new
    config.govuk_notify.custom_url = ENV.fetch('GOVUK_NOTIFY_CUSTOM_URL', false)
    if ENV.key?('GOVUK_NOTIFY_API_KEY_LIVE')
      config.govuk_notify.enabled = true
      config.govuk_notify.live_api_key = ENV['GOVUK_NOTIFY_API_KEY_LIVE']
      config.govuk_notify.team_api_key = ENV['GOVUK_NOTIFY_API_KEY_TEAM']
      config.govuk_notify.test_api_key = ENV['GOVUK_NOTIFY_API_KEY_TEST']
      config.govuk_notify.mode = :live
    else
      config.govuk_notify.enabled = false
    end

    config.maintenance_enabled = ENV.fetch('MAINTENANCE_ENABLED', 'false').downcase == 'true'
    config.maintenance_allowed_ips = ENV.fetch('MAINTENANCE_ALLOWED_IPS', '').split(',').map(&:strip)
    config.maintenance_end = ENV.fetch('MAINTENANCE_END', nil)
    config.et_gds_design_system.api_url = ENV.fetch('ET_API_URL', 'http://api.et.127.0.0.1.nip.io:3100/api')
  end
end
