class ClaimsController < ApplicationController
  before_action :ensure_claim_in_progress, only:   %i<show update>
  skip_before_action :ensure_claim_exists, except: %i<show update>

  def new
    @claim = Claim.new
    session.clear
  end

  def create
    claim = Claim.create
    session[:claim_reference] = claim.reference

    redirect_to edit_user_session_url
  end

  def update
    resource.assign_attributes params[current_step]

    saved = resource.save

    if params[:return]
      redirect_to user_session_path
    else
      if saved
        redirect_to page_claim_path(page: transition_manager.forward)
      else
        render action: :show
      end
    end
  end

  private

  def transition_manager
    @transition_manager ||= ClaimTransitionManager.new(resource: resource)
  end

  def referring_step
    Rails.application.routes.recognize_path(request.referer)[:page]
  end

  helper_method def resource
    @form ||= Form.for(current_step).new { |f| f.resource = claim }
  end

  helper_method def current_step
    (params[:page] || referring_step).underscore
  end

  helper_method def fee_calculation
    @fee_calculation ||= claim.fee_calculation
  end
end
