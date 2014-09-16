class UserSessionsController < ApplicationController
  skip_before_action :ensure_claim_exists, except: :destroy

  def new
    session.clear
  end

  def show
    user_session.reference = session[:claim_reference]
  end

  def create
    if user_session.save
      session[:claim_reference] = user_session.reference
      redirect_to page_claim_path(page: 'claimant')
    else
      render 'new'
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

  helper_method def user_session
    @user_session ||= UserSession.new(params[:user_session])
  end
end
