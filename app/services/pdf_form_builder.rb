class PdfFormBuilder
  ET1_PDF_PATH = Rails.root.join(Rails.root, 'lib', 'assets', 'et001-eng.pdf').to_s.freeze
  ET1_PDF_PATH_CY = Rails.root.join(Rails.root, 'lib', 'assets', 'et1-cym.pdf').to_s.freeze
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
    pdf_builder.fill_form(pdf_template_path, tempfile, document_data, flatten: !Rails.env.test?)
    yield tempfile
    tempfile.close!
  end

  private

  def pdf_template_path
    if I18n.locale.to_s == 'en'
      ET1_PDF_PATH
    else
      ET1_PDF_PATH_CY
    end
  end

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
