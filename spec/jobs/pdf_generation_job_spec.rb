require 'rails_helper'

describe PdfGenerationJob, type: :job do
  let(:claim) { object_double Claim.new }
  let(:pdf_generation_job) { PdfGenerationJob.new }

  describe '#perform' do
    it 'generates the pdf' do
      expect(claim).to receive(:generate_pdf!)
      pdf_generation_job.perform(claim)
    end
  end
end
