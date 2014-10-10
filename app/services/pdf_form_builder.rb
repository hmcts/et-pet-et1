class PdfFormBuilder
  def initialize(claim)
    @pdftk = PdfForms.new('pdftk')
    @claim = claim
    @presenter = PdfForm::ClaimPresenter.new(@claim)
  end

  def filename
    "et1_#{@presenter.name.downcase.gsub(' ', '_')}"
  end

  def to_pdf
    fields = @presenter.to_h
    pdf_path =  "tmp/claim#{@claim.id}.pdf"
    @pdftk.fill_form('lib/assets/et001-eng.pdf', pdf_path, fields, flatten: !Rails.env.test?)
    File.read(pdf_path)
  end
end
