class UserSessionsController < ApplicationController
  redispatch_request unless: :present?, except: %i<new create>

  before_action :hide_signout

  def destroy
    case
    when claim.email_address.present?
      logout
    when params[:user_session].present?
      send_access_details_and_logout
    else
      render 'reminder'
    end
  end

  def create
    if user_session.valid?
      session[:claim_reference] = user_session.reference
      claim.create_event Event::LOGIN, actor: 'user'
      redirect_to claim_path_for :claimant
    else
      render :new
    end
  end

  def touch
    render nothing: true
  end

  private

  def logout
    claim.create_event Event::LOGOUT, actor: 'user'
    reset_session
    redirect_to root_path, notice: t('.logout')
  end

  def send_access_details_and_logout
    claim.update_attributes(email_address: user_session.email_address)
    deliver_access_details
    logout
  end

  def deliver_access_details
    AccessDetailsMailer.deliver_later claim
    claim.create_event Event::DELIVER_ACCESS_DETAILS, message: "Sent to #{claim.email_address}"
  end

  def user_session
    @user_session ||= UserSession.new(params[:user_session])
  end

  helper_method :user_session
end
