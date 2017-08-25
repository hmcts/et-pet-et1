Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.preview_path = Rails.root.join('spec', 'mailer_previews')

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # This makes rails serve all the assets from under /apply as they are in prod.
  config.assets.prefix = "apply/assets"
  config.relative_url_root = ""

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  # Rack livereload for frontend development
  config.middleware.use Rack::LiveReload, source: :vendored

  config.action_mailer.default_url_options = {
    host: 'localhost', protocol: 'http', port: 3000
  }

  config.action_mailer.default_options = { from: 'no-reply@lol.biz.info' }
  config.active_job.queue_adapter = :sidekiq

end

Slim::Engine.set_default_options pretty: true, sort_attrs: true
CarrierWave.configure do |config|
  config.storage :file
end
