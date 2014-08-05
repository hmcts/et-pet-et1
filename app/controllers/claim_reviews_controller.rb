class ClaimReviewsController < ApplicationController
  before_action :ensure_claim_in_progress
  
  helper_method def presenter
    @presenter ||= ClaimPresenter.new(claim)
  end
end
