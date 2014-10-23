class ClaimReviewsController < ApplicationController
  before_action :ensure_claim_in_progress

  def update
    claim.submit!
    attempt_send_confirmation_email
    redirect_to claim.payment_required? ? page_claim_path(page: 'pay') : claim_confirmation_path
  end

  private

  def attempt_send_confirmation_email
    if email_addresses.any?
      BaseMailer.confirmation_email(claim, email_addresses).deliver_later
    end
  end

  def email_addresses
    params[:confirmation_email][:email_addresses].reject(&:blank?)
  end
end
