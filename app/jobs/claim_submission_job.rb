class ClaimSubmissionJob < ActiveJob::Base
  queue_as :claim_submission

  def perform(claim)
    Rails.logger.info "Starting ClaimSubmissionJob"

    claim.generate_pdf!
    EtApi.create_claim claim

    if claim.confirmation_email_recipients?
      BaseMailer.confirmation_email(claim).deliver
      claim.create_event Event::CONFIRMATION_EMAIL_SENT
    end

    Rails.logger.info "Finished ClaimSubmissionJob"
  end
end
