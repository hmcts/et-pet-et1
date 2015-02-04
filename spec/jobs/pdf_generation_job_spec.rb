require 'rails_helper'

describe PdfGenerationJob, type: :job do
  let(:claim)  { object_double Claim.new }

  describe '#perform' do
    it 'generates the pdf' do
      expect(claim).to receive(:generate_pdf!)
      subject.perform(claim)
    end
  end
end
