class ErrorsController < ApplicationController

  def not_found
    respond_to do |format|
      format.json { render json: { status: 404, error: 'Not Found' } }
      format.html { render(status: :not_found) }
    end
  end

  def unprocessable
    respond_to do |format|
      format.json { render json: { status: 422, error: 'Unprocessable Entity' } }
      format.html { render(status: :unprocessable_entity) }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.json { render json: { status: 500, error: 'Internal Server Error' } }
      format.html { render(status: :internal_server_error) }
    end
  end

  def service_unavailable
    respond_to do |format|
      format.json { render json: { status: 503, error: 'Service Unavailable' } }
      format.html { render(status: :service_unavailable) }
    end
  end
end
