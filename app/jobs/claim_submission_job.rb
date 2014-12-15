class ClaimSubmissionJob < ActiveJob::Base
  queue_as :claim_submission

  def perform(claim)
    claim.generate_pdf!
    Jadu::Claim.create claim
    BaseMailer.confirmation_email(claim).deliver if claim.confirmation_email_recipients?
  end
end
