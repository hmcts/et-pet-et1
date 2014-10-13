class UserSessionsController < ApplicationController
  skip_before_action :ensure_claim_exists, except: :destroy
  before_action :get_claim_reference, only: %i<show edit update>

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

  def update
    if user_session.save
      claim.update_attribute(:password, user_session.password)
      deliver_access_details
      redirect_to page_claim_path(page: 'claimant')
    else
      render 'edit'
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

  def get_claim_reference
    user_session.reference = session[:claim_reference]
  end

  def deliver_access_details
    if user_session.email_address.present?
      BaseMailer.access_details_email(claim, user_session.email_address).deliver_later
    else
      true
    end
  end

  helper_method def user_session
    @user_session ||= UserSession.new(params[:user_session])
  end
end
