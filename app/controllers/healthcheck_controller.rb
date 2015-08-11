class HealthcheckController < ActionController::Base
  def index
    render json: report, status: http_status_code
  end

  private

  delegate :report, :http_status_code, to: :healthcheck

  def healthcheck
    @healthcheck ||= Healthcheck.report
  end
end
