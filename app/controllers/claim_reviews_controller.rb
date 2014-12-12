class ClaimReviewsController < ApplicationController
  redispatch_request unless: :created?
  before_action :check_session_expiry

  def update
    claim.update confirmation_email_recipients: email_addresses
    claim.submit!
    redirect_to claim.payment_required? ? claim_payment_path : claim_confirmation_path
  end

  private

  def email_addresses
    params[:confirmation_email][:email_addresses].reject(&:blank?)
  end
end
