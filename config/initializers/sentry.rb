Sentry.init do |config|
  config.dsn = ENV.fetch('RAVEN_DSN', '')
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 1.0
  ENV.fetch('APPVERSION', 'unknown').tap do |version|
    next if version == 'unknown'

    config.release = version
  end
end
