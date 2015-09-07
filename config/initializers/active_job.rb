ActiveJob::Base.queue_adapter = :sidekiq
Sidekiq.configure_server do |config|
   config.server_middleware do |chain|
      chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 0
   end
end

