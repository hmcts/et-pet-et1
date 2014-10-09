class ClaimConfirmationsController < ApplicationController
  before_action :ensure_claim_is_finished

  private def ensure_claim_is_finished
    redirect_to root_path unless claim.enqueued_for_submission? || claim.submitted?
  end

  def generated_claim
    respond_to do |format|
      pdf_form = PdfFormBuilder.new(claim)
      format.pdf { render pdf: pdf_form, filename: pdf_form.filename }
    end
  end
end
