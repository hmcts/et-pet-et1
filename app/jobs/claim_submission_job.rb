class ClaimSubmissionJob < ActiveJob::Base
  queue_as :claim_submission

  def perform(claim)
    Jadu::Claim.create claim
  end
end
