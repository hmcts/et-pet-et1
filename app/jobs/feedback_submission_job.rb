class FeedbackSubmissionJob < ActiveJob::Base
  queue_as :feedback_submission

  def perform(params)
    Rails.logger.info "Starting FeedbackSubmissionJob"
    FeedbackMailer.with(comments: params[:comments], suggestions: params[:suggestions], requester: { email: email_from(params), name: "ET User" }).service_now_email.deliver_now

    Rails.logger.info "Finished FeedbackSubmissionJob"
  end

  private

  def email_from(params)
    if params[:email_address].present?
      params[:email_address]
    else
      "anonymous@example.com"
    end
  end

  def client
    @client ||= ZendeskAPI::Client.new do |config|
      config.url      = ENV.fetch('ZENDESK_URL')
      config.username = ENV.fetch('ZENDESK_USER')
      config.token    = ENV.fetch('ZENDESK_TOKEN')
      config.logger   = Rails.logger
    end
  end
end
