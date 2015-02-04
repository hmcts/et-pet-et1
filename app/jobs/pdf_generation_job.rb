class PdfGenerationJob < ActiveJob::Base
  queue_as :pdf_generation

  def perform(claim)
    claim.generate_pdf!
  end
end
