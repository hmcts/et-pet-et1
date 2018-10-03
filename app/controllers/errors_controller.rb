class ErrorsController < ApplicationController

  def not_found
    render(:status => 404)
  end

  def unprocessable
    render(:status => 422)
  end

  def internal_server_error
    render(:status => 500)
  end

  def service_unavailable
    render(:status => 503)
  end
end
