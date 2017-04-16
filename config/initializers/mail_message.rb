require 'mail'

Mail::Message.class_eval do
  alias_method :original_deliver, :deliver

  def deliver
    original_deliver
  rescue => e
    Rails.logger.warn "Failed to send email with subject '#{subject}': #{e.inspect}"
  end
end
