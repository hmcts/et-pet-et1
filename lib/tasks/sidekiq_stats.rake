require 'sidekiq/api'

desc 'report basic sidekiq stats'
task :sidekiq_stats do
  stats = Sidekiq::Stats.new

  log_info = {
      '@timestamp' => Time.new.getutc.iso8601,
      'enqueued' => stats.enqueued,
      'retry_size' => stats.retry_size,
      'scheduled_size' => stats.scheduled_size,
      'queues' => stats.queues
  }

  puts log_info.to_json
end
