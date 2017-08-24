class FeedbackSubmissionJob < ActiveJob::Base
  queue_as :feedback_submission

  def perform(params)
    Rails.logger.info "Starting FeedbackSubmissionJob"

    ZendeskAPI::Ticket.create(client,
      subject: "New ATET User Feedback",
      comment: { value: body_from(params) },
      requester: { email: email_from(params), name: "ET User" },
      group_id: ENV.fetch('ZENDESK_GROUP_ID'))

    Rails.logger.info "Finished FeedbackSubmissionJob"
  end

  private

  def body_from(params)
    ['Comments', 'Suggestions'].
      zip(params.values_at(:comments, :suggestions)).join("\n\n")
  end

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
