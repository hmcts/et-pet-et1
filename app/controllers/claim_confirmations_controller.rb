class ClaimConfirmationsController < ApplicationController
  redispatch_request unless: :immutable?

  def fee_calculation
    @fee_calculation ||= claim.fee_calculation
  end

  helper_method :fee_calculation

  def generated_claim
    respond_to do |format|
      pdf_form = PdfFormBuilder.new(claim)
      format.pdf { render pdf: pdf_form, filename: pdf_form.filename }
    end
  end
end
