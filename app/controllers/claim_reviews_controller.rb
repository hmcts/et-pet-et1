class ClaimReviewsController < ApplicationController
  redispatch_request unless: :created?
  before_action :check_session_expiry

  def update
    claim.update confirmation_email_recipients: email_addresses
    claim.submit!
    redirect_to claim.payment_required? ? claim_payment_path : claim_confirmation_path
  end

  def show
    render locals: {
      primary_claimant: claim.primary_claimant || null_object,
      representative: claim.representative || null_object,
      employment: claim.employment || null_object,
      respondent: claim.primary_respondent || null_object,
      secondary_claimants: claim.secondary_claimants,
      secondary_respondents: claim.secondary_respondents
    }
  end

  private

  def email_addresses
    params[:confirmation_email][:email_addresses].reject(&:blank?)
  end
end
