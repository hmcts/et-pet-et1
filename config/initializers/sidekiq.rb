Sidekiq.configure_server do |config|
  redis_config = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') }
  redis_config[:password] = ENV['REDIS_PASSWORD'] if ENV['REDIS_PASSWORD'].present?
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  redis_config = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') }
  redis_config[:password] = ENV['REDIS_PASSWORD'] if ENV['REDIS_PASSWORD'].present?
  config.redis = redis_config
end

Sidekiq::Logging.logger.level = ::Logger.const_get(ENV.fetch('RAILS_LOG_LEVEL', 'debug').upcase)
