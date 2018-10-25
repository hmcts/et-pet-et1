class PdfFormBuilder
  ET1_PDF_PATH = Rails.root.join(Rails.root, 'lib', 'assets', 'et001-eng.pdf').to_s.freeze
  attr_reader :claim

  def initialize(claim)
    @claim = claim
  end

  class << self
    def build(claim, &block)
      new(claim).tap { |p| p.perform(&block) }
    end
  end

  def perform(&_block)
    pdf_builder.fill_form(ET1_PDF_PATH, tempfile, document_data, flatten: Rails.application.config.flatten_pdf)
    yield tempfile
    tempfile.close!
  end

  private

  def pdf_builder
    @pdf_builder ||= PdfForms.new('pdftk')
  end

  def presenter
    @presenter ||= PdfForm::ClaimPresenter.new(claim)
  end

  def document_data
    presenter.to_h
  end

  def tempfile
    @tempfile ||= Tempfile.new("#{claim.id}.pdf")
  end
end
