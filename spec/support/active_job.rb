RSpec.configure do |config|
  # This should not be required, but the active job test helper can leave the adapter
  # as nil due to a bug in active job queue adapter code.
  # But, no harm should be done by this, so even if the active job is fixed (Rails 4.2.1 fixes it), this can stay
  config.before(:each) do
    ActiveJob::Base.queue_adapter = Rails.application.config.active_job.queue_adapter
  end
end
