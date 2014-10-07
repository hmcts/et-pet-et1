class PdfFormBuilder
  def initialize(claim)
    @pdftk = PdfForms.new(ENV['PDFTK_PATH'])
    @claim = claim
  end

  def to_pdf
    fields = PdfForm::ClaimPresenter.new(@claim).to_h
    pdf_path =  "tmp/claim#{@claim.id}.pdf"
    @pdftk.fill_form('lib/assets/et001-eng.pdf', pdf_path, fields)
    File.read(pdf_path)
  end
end
