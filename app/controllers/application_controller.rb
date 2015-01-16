class ApplicationController < ActionController::Base
  include SignoutVisibility

  protect_from_forgery with: :exception
  after_action :set_session_expiry

  before_action do
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"]        = "no-cache"
    response.headers["Expires"]       = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  class << self
    def redispatch_request(opts={})
      state = opts.delete(:unless)
      before_action(opts) { redispatch_request!(state) }
    end
  end

  private

  def redispatch_request!(state)
    unless claim.try(state)
      redirect_to case
                  when claim.nil?
                    root_path
                  when claim.created?
                    claim_claimant_path
                  when claim.payment_required?
                    claim_payment_path
                  when claim.immutable?
                    claim_confirmation_path
                  end
    end
  end

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
