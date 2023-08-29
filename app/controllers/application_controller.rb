class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :show_maintenance_page
  after_action :set_sentry_context
  after_action :set_session_expiry

  before_action do
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"]        = "no-cache"
    response.headers["Expires"]       = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  before_action :set_locale

  def default_url_options
    return {} if @active_admin

    { locale: I18n.locale }
  end

  class << self
    def redispatch_request(opts = {})
      states = Array(opts.delete(:unless))
      before_action(opts) do
        redispatch_request! unless states.any? { |state| claim.try state }
      end
    end
  end

  private

  def redispatch_request!
    redirect_to redispatch_link
  end

  def redispatch_link
    if claim.nil?
      root_path
    elsif claim.created?
      claim_claimant_path
    elsif claim.immutable?
      claim_confirmation_path
    end
  end

  def set_session_expiry
    session[:expires_in] = 1.hour.from_now
  end

  def check_session_expiry
    return unless session[:expires_in]

    if Time.current > session[:expires_in]
      redirect_to expired_timeout_session_path
    end
  end

  def expired_session?
    Time.current > session[:expires_in]
  rescue StandardError
    false
  end

  def set_sentry_context
    return unless claim&.id.present? && claim&.application_reference.present? && claim&.user&.id.present?

    Sentry.with_scope do |scope|
      scope.set_extras(claim_id: claim.id, application_reference: claim.application_reference, user_id: claim.user.id)
    end
  end

  def claim
    @claim ||= load_claim_from_session
  end

  def load_claim_from_session
    return nil if session[:claim_reference].blank?

    Claim.find_by(application_reference: session[:claim_reference])
  end

  def claim_path_for(page, options = {})
    send "claim_#{page}_path".underscore, options
  end

  helper_method :claim, :claim_path_for

  def set_locale
    session[:locale] = params[:locale] if params[:locale] && valid_locale?
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def valid_locale?
    I18n.available_locales.include?(params[:locale].to_sym)
  end

  def set_admin_locale
    @active_admin = true
    I18n.locale = :en
  end

  def show_maintenance_page(config = Rails.application.config)
    return if !config.maintenance_enabled || config.maintenance_allowed_ips.include?(request.remote_ip)

    render 'static_pages/maintenance', layout: false, status: :service_unavailable
  end
end
