module TimeHelper
  def session_expiry_time
    61.minutes.from_now
  end

  extend self
end
