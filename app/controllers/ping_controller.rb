class PingController  < ApplicationController
  respond_to :json

  skip_before_action :ensure_claim_exists

  def index
    respond_with Deployment.info
  end
end
