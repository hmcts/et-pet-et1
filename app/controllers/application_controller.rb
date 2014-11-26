class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :set_session_expiry

  class << self
    def redispatch_request(opts={})
      states = Array(opts.delete(:unless))

      before_action opts do
        destination =
        case
        when claim.nil?
          root_path
        when claim.created?
          claim_claimant_path
        when claim.payment_required?
          claim_payment_path
        when claim.enqueued_for_submission?, claim.submitted?
          claim_confirmation_path
        end

        redirect_to destination unless states.any? { |s| claim.try s }
      end
    end
  end

  private

  def set_session_expiry
    session[:expires_in] = 1.hour.from_now
  end

  def check_session_expiry
    if Time.now > session[:expires_in]
      redirect_to session_expired_user_session_path
    end
  end

  def claim
    @claim ||= load_claim_from_session
  end

  def load_claim_from_session
    return nil unless session[:claim_reference].present?
    Claim.find_by_reference(session[:claim_reference])
  end

  def claim_path_for(page, options = {})
    send "claim_#{page}_path".underscore, options
  end

  helper_method :claim, :claim_path_for
end
