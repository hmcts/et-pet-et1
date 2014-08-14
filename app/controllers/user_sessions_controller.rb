class UserSessionsController < ApplicationController

  def new
    session.clear
  end

  def create
    if user_session.save
      session[:claim_reference] = user_session.reference
      redirect_to page_claim_path(page: 'claimant')
    else
      render 'new'
    end
  end

  private

  helper_method def user_session
    @user_session ||= UserSession.new(params[:user_session])
  end
end
