require 'sneakers/handlers/maxretry'

if Rails.env.production?
  Sneakers.configure \
    amqp:    "amqp://#{ENV.fetch('RABBIT_USER')}:#{ENV.fetch('RABBIT_PASSWORD')}@#{ENV.fetch('RABBIT_HOST')}:#{ENV.fetch('RABBIT_PORT')}",
    vhost:   ENV.fetch('RABBIT_VHOST'),
    workers: Integer(ENV.fetch('SNEAKERS_WORKERS')),
    durable: true,
    handler: Sneakers::Handlers::Maxretry,
    log:     STDOUT,
    heartbeat: 28,
    timeout_job_after: Integer(ENV.fetch('SNEAKERS_TIMEOUT_S')),
    retry_timeout: Integer(ENV.fetch('SNEAKERS_RETRY_TTL_MS')), #milliseconds
    max_retries: Integer(ENV.fetch('SNEAKERS_MAX_RETRIES')),
    hooks: {
        before_fork: -> {
          Sneakers.logger.info('Worker: Disconnect from the database')
          ActiveRecord::Base.connection_pool.disconnect!
        },
        after_fork: -> {
          config = Rails.application.config.database_configuration[Rails.env]
          config['pool'] = Integer(ENV.fetch('SNEAKERS_DB_POOL', 1)) #Limit the number of TCP connections per worker
          ActiveRecord::Base.establish_connection(config)
          Sneakers.logger.info('Worker: Reconnect to the database')
        }
    }

  Rails.application.config.active_job.queue_adapter = :sneakers
end

class ETJobWrapper < ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper
  def work(*)
    ActiveRecord::Base.connection_pool.with_connection do
      super
    end
  end
end
