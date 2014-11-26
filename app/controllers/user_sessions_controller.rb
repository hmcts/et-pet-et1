class UserSessionsController < ApplicationController
  redispatch_request unless: :present?, except: %i<update returning create>

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
    reset_session
    redirect_to root_path
  end

  def session_expired
    reset_session
  end

  def refresh_session
    render nothing: true
  end

  private

  def deliver_access_details
    AccessDetailsMailer.deliver_later claim
  end

  def email_address_already_set?
    claim.email_address.present?
  end

  def user_session
    @user_session ||= UserSession.new(params[:user_session])
  end

  helper_method :user_session
end
