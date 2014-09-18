module PaymentGateway
  # Assume payment gateway is up until we find it isn't. Because classes are
  # reloaded every request in development, it creates a race condition where
  # PaymentGateway.available? may be nil in the request. Because classes are
  # cached in test and also eager loaded in production this shouldn't be a problem
  # in those environments, but it's annoying in development
  @available = true
  MUTEX = Mutex.new

  TASK = PeriodicTask.new(every: 5.seconds, run_immediately: !Rails.env.test?) do
    begin
      result = HTTParty.get ENV.fetch('PAYMENT_GATEWAY_PING_ENDPOINT')
      MUTEX.synchronize { @available = result.success? }
    rescue SystemCallError
      MUTEX.synchronize { @available = false }
    end
  end

  def available?
    MUTEX.synchronize { @available }
  end

  delegate :run, :stop, to: :TASK

  extend self
end
