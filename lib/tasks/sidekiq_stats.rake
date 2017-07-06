require 'sidekiq/api'

desc 'report basic sidekiq stats'
task sidekiq_stats: :environment do
  stats = Sidekiq::Stats.new

  enqueued_submissions = Claim.where(state: :enqueued_for_submission).
                         where('submitted_at < ?', 20.minutes.ago).count

  log_info = {
    '@timestamp' => Time.new.getutc.iso8601,
    'enqueued' => stats.enqueued,
    'retry_size' => stats.retry_size,
    'scheduled_size' => stats.scheduled_size,
    'queues' => stats.queues,
    'enqueued_submissions' => enqueued_submissions
  }
  puts log_info.to_json

end
