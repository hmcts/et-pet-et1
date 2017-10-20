RSpec.configure do |config|
  # This should not be required, but the active job test helper can leave the adapter
  # as nil due to a bug in active job queue adapter code.
  # But, no harm should be done by this, so even if the active job is fixed (Rails 4.2.1 fixes it), this can stay
  config.before(:each) do
    ActiveJob::Base.queue_adapter = Rails.application.config.active_job.queue_adapter
  end

  module ActiveJobPerformHelper
    def perform_active_jobs(klass)
      job_specs = queue_adapter.enqueued_jobs.select { |job_spec| job_spec[:job] == klass }
      job_specs.each do |job_spec|
        job = job_spec[:job].new(*ActiveJob::Arguments.deserialize(job_spec[:args]))
        job.perform_now
      end
    end
  end
end
