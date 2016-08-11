class PdfGenerationJob < ActiveJob::Base
  queue_as :pdf_generation

  def perform(claim)
    Rails.logger.info "Starting PdfGenerationJob"
    claim.generate_pdf!
    Rails.logger.info "Finished PdfGenerationJob"
  end
end
