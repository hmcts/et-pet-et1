class ClaimsController < ApplicationController
  before_action :ensure_claim_in_progress, only: %i<show update>

  def new
    @claim = Claim.new
    session.clear
  end

  def create
    claim = Claim.create
    session[:claim_reference] = claim.reference

    redirect_to page_claim_path(page: 'password')
  end

  def update
    resource.assign_attributes params[current_step]

    if resource.save
      redirect_to page_claim_path(page: transition_manager.forward)
    else
      render action: :show
    end
  end

  private

  def ensure_claim_in_progress
    redirect_to root_path unless session[:claim_reference].present?
  end

  def transition_manager
    @transition_manager ||= ClaimTransitionManager.new(resource: resource)
  end

  def referring_step
    Rails.application.routes.recognize_path(request.referer)[:page]
  end

  helper_method def claim
    @claim ||= Claim.find_by_reference(session[:claim_reference])
  end

  helper_method def resource
    @form ||= Form.for(current_step).new { |f| f.resource = claim }
  end

  helper_method def current_step
    params[:page] || referring_step
  end
end
