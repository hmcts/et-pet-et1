class PdfGenerationJob < ActiveJob::Base
  include EtBaseJob
  queue_as :pdf_generation

  def perform(claim)
    claim.generate_pdf!
  end
end
