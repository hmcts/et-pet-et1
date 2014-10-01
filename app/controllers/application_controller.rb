class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_claim_exists

  private

  def ensure_claim_exists
    redirect_to root_path unless claim.present?
  end

  def ensure_claim_in_progress
    redirect_to root_path unless claim.created?
  end

  helper_method def claim
    # session[:claim_reference] = Claim.last.reference

    @claim ||= if session[:claim_reference].present?
      Claim.find_by_reference(session[:claim_reference])
    end
  end
end
