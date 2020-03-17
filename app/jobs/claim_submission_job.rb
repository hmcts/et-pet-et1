class ClaimSubmissionJob < ActiveJob::Base
  queue_as :claim_submission

  def perform(claim, uuid)
    Rails.logger.info "Starting ClaimSubmissionJob"

    claim.generate_pdf!
    EtApi.create_claim claim, uuid: uuid
    claim.finalize!

    Rails.logger.info "Finished ClaimSubmissionJob"
  end
end
