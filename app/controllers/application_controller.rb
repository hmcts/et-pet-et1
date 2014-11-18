class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :ensure_claim_exists
  after_action :set_session_expiry

  private

  def ensure_claim_exists
    redirect_to root_path unless claim.present?
  end

  def ensure_claim_in_progress
    redirect_to root_path unless claim.created?
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
