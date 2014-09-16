class ClaimConfirmationsController < ApplicationController
  before_action :ensure_claim_is_finished

  private def ensure_claim_is_finished
    redirect root_path unless claim.enqueued_for_submission? || claim.submitted?
  end
end
