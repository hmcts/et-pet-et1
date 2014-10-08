class ClaimConfirmationsController < ApplicationController
  respond_to :html, :pdf

  before_action :ensure_claim_is_finished

  private def ensure_claim_is_finished
    redirect_to root_path unless claim.enqueued_for_submission? || claim.submitted?
  end

  def show
    respond_to {|format| format.html}
  end

  def generated_claim
    respond_to do |format|
      pdf_form = PdfFormBuilder.new(claim)
      format.pdf { render pdf: pdf_form, filename: pdf_form.filename }
    end
  end
end
