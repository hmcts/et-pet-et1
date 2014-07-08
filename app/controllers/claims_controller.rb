class ClaimsController < ApplicationController
  def new
    @claim = Claim.new
    session.clear
  end

  def create
    redirect_to claim_path(Claim.create)
  end

  def update
    resource.assign_attributes params[session_manager.current_step]

    if resource.save
      redirect_to_next_step
    else
      render action: :show
    end
  end

  private

  def redirect_to_next_step
    session_manager.perform!(resource: resource)
    redirect_to claim_path(@claim)
  end

  helper_method def session_manager
    @session_manager ||= ClaimSessionTransitionManager.new(session: session)
  end

  helper_method def claim
    @claim ||= Claim.find_by_reference(params[:id])
  end

  helper_method def resource
    @form ||= Form.for(session_manager.current_step).new { |f| f.resource = claim }
  end

end
