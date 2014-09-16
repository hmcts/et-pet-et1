class ClaimReviewsController < ApplicationController
  before_action :ensure_claim_in_progress

  helper_method def presenter
    @presenter ||= ClaimPresenter.new(claim)
  end

  def update
    claim.submit!
    redirect_to claim.payment_required? ? page_claim_path(page: 'pay') : claim_confirmation_path
  end
end
