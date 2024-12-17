redis_url = Rails.application.config.redis_url
Sidekiq.configure_server do |config|
  redis_config = { url: redis_url }
  redis_config[:password] = ENV['REDIS_PASSWORD'] if ENV['REDIS_PASSWORD'].present?
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  redis_config = { url: redis_url }
  redis_config[:password] = ENV['REDIS_PASSWORD'] if ENV['REDIS_PASSWORD'].present?
  config.redis = redis_config
end

Sidekiq.logger.level = Logger.const_get(ENV.fetch('RAILS_LOG_LEVEL', 'debug').upcase)
