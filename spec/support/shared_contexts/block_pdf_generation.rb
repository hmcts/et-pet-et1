shared_context 'block pdf generation' do
  before do
    pdf_double = object_double(PdfForms.new('pdftk'), fill_form: nil)
    allow(PdfForms).to receive(:new).and_return pdf_double
  end
end
