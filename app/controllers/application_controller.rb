class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def ensure_claim_in_progress
    redirect_to root_path unless session[:claim_reference].present?
  end

  helper_method def claim
    @claim ||= Claim.find_by_reference(session[:claim_reference])
  end
end
