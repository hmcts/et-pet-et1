class TimeoutSessionsController < ApplicationController
  skip_after_action :set_session_expiry, only: :expired
  redispatch_request unless: :present?, except: [:new, :create]

  def destroy
    if claim.user&.email.present?
      logout
    elsif params[:user_session].present?
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
    head :ok
  end

  def expired
    reset_session
  end

  private

  def logout
    claim.create_event Event::LOGOUT, actor: 'user'
    reset_session
    redirect_to apply_path(locale: I18n.locale), flash: { info: t('.logout') }
  end

  def send_access_details_and_logout
    return unless claim.user.present?

    claim.user.update(email: user_session.email_address)
    deliver_access_details
    logout
  end

  def deliver_access_details
    AccessDetailsMailer.deliver_later claim
    claim.create_event Event::DELIVER_ACCESS_DETAILS, message: "Sent to #{claim.user.email}"
  end

  def user_session
    @user_session ||= UserSession.new(user_session_params.to_unsafe_hash)
  end

  def user_session_params
    params.require(:user_session).permit(:reference, :password, :email_address)
  rescue ActionController::ParameterMissing
    ActionController::Parameters.new
  end

  helper_method :user_session
end
