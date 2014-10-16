class ClaimReviewsController < ApplicationController
  before_action :ensure_claim_in_progress

  def update
    claim.submit!

    if email_addresses.any?
      BaseMailer.confirmation_email(claim, email_addresses).deliver_later
    end

    redirect_to claim.payment_required? ? page_claim_path(page: 'pay') : claim_confirmation_path
  end

  private

  def email_addresses
    addresses = params[:confirmation_email]
    (addresses[:email_addresses] + addresses[:additional_email_address].values).reject(&:blank?)
  end
end
