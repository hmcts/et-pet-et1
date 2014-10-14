require 'rails_helper'

RSpec.describe PdfFormBuilder, type: :service do
  let(:pdf_forms) { double fill_form: nil }
  let(:claim) { double id: 1 }
  let(:claim_presenter) { double name: 'name', to_h: {fields: 'fields'} }
  let(:et1_pdf_path) { 'lib/assets/et001-eng.pdf' }
  subject { described_class.new(claim) }

  before do
    allow(File).to receive(:read).and_return('pdf')
    allow(PdfForms).to receive(:new).and_return(pdf_forms)
    allow(PdfForm::ClaimPresenter).to receive(:new).and_return(claim_presenter)
  end

  describe '#filename' do
    it 'returns a filename' do
      expect(subject.filename).to eq('et1_name')
    end
  end

  describe '#to_pdf' do
    it 'returns filled in ET1 pdf' do
      pdf = subject.to_pdf

      expect(pdf).to eq('pdf')
      expect(pdf_forms).to have_received(:fill_form).with(
        et1_pdf_path, 'tmp/claim1.pdf', {fields: 'fields'}, flatten: false)
    end

    it 'ensure ET1 PDF exists' do
      expect(File).to exist(et1_pdf_path)
    end
  end
end
