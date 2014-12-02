class ClaimSubmissionJob < ActiveJob::Base
  queue_as :claim_submission

  def perform(claim)
    claim.generate_pdf!
    Jadu::Claim.create claim
  end
end
