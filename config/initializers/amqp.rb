require 'sneakers/handlers/maxretry'

if Rails.env.production?
  Sneakers.configure \
    amqp:    "amqp://#{ENV.fetch('RABBIT_USER')}:#{ENV.fetch('RABBIT_PASSWORD')}@#{ENV.fetch('RABBIT_HOST')}:#{ENV.fetch('RABBIT_PORT')}",
    vhost:   ENV.fetch('RABBIT_VHOST'),
    durable: true,
    handler: Sneakers::Handlers::Maxretry,
    log:     'log/sneakers.log',
    timeout_job_after: 15, # Timeout job after 15 seconds
    retry_timeout: 120_000 # TTL of 2 minutes before routing to deadletter queue

  Rails.application.config.active_job.queue_adapter = :sneakers
end
