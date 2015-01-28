require 'sneakers/handlers/maxretry'

if Rails.env.production?
  Sneakers.configure \
    amqp:    "amqp://#{ENV.fetch('RABBIT_USER')}:#{ENV.fetch('RABBIT_PASSWORD')}@#{ENV.fetch('RABBIT_HOST')}:#{ENV.fetch('RABBIT_PORT')}",
    vhost:   ENV.fetch('RABBIT_VHOST'),
    durable: true,
    handler: Sneakers::Handlers::Maxretry,
    log:     'log/sneakers.log',
    timeout_job_after: ENV.fetch('SNEAKERS_TIMEOUT_S').to_i,
    retry_timeout: ENV.fetch('SNEAKERS_RETRY_TTL_MS').to_i, #milliseconds
    max_retries: ENV.fetch('SNEAKERS_MAX_RETRIES').to_i

  Rails.application.config.active_job.queue_adapter = :sneakers
end
