class ClaimSubmissionJob < ActiveJob::Base
  queue_as :claim_submission

  def perform(claim)
    claim.generate_pdf!
    Jadu::Claim.create claim

    if claim.confirmation_email_recipients?
      BaseMailer.confirmation_email(claim).deliver
      claim.create_event Event::CONFIRMATION_EMAIL_SENT
    end
  end
end
