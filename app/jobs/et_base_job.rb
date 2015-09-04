module EtBaseJob
  def self.included(klass)
    klass.include ActiveJob::Retry
    # TODO: read these in from env vars:
    klass.constant_retry limit: 3, delay: 1.minutes, retryable_exceptions: [Exception]
  end
end

