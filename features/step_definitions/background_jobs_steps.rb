include ActiveJob::TestHelper

And(/^all background jobs for claim submissions are processed$/) do
  perform_enqueued_jobs do
    jobs = queue_adapter.enqueued_jobs.select { |job_spec| job_spec[:job] == ClaimSubmissionJob }
    jobs.each do |job_spec|
      job_spec[:job].perform_now(*ActiveJob::Arguments.deserialize(job_spec[:args]))
    end
  end
end
