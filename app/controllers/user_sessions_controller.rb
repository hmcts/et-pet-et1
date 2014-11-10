class UserSessionsController < ApplicationController
  skip_before_action :ensure_claim_exists, except: :update

  def reminder
    redirect_to root_path if email_address_already_set?
  end

  def create
    if user_session.valid?
      session[:claim_reference] = user_session.reference
      redirect_to claim_path_for :claimant
    else
      render :returning
    end
  end

  def update
    claim.update_attributes(email_address: user_session.email_address)
    deliver_access_details
    session.clear
    redirect_to root_path
  end

  private

  def deliver_access_details
    AccessDetailsMailer.deliver_later claim
  end

  def email_address_already_set?
    claim.email_address.present?
  end

  helper_method def user_session
    @user_session ||= UserSession.new(params[:user_session])
  end
end
