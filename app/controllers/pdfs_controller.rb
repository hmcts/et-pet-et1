class PdfsController < ApplicationController
  redispatch_request unless: :immutable?

  def show
    redirect_to claim.pdf_url if claim.pdf_present?
  end
end
