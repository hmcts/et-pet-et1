class ErrorTestsController < ApplicationController
  before_action :authorize_error_test_access

  def create
    raise 'Deliberate Ruby error triggered from the hidden error test page'
  end

  private

  def authorize_error_test_access
    configured_token = Rails.application.config.error_test_page_token
    provided_token = params[:token].to_s

    return not_found if configured_token.blank?
    return if ActiveSupport::SecurityUtils.secure_compare(provided_token, configured_token)

    not_found
  end

  def not_found
    head :not_found
  end
end
