if Rails.env.production? || Rails.env.local?
  Rails.application.config.active_job.queue_adapter = :sidekiq
end
