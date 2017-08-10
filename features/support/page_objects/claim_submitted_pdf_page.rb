class ClaimSubmittedPdfPage < BasePage
  set_url "/uploads/claim/pdf{/p1}{/p2}"

  # This is a fake section which makes the pdf content matchable using normal capybara methods
  # even though pdf is nothing like html
  def pdf_content
    @pdf_content ||= PdfContent.new(current_url)
  end

end

class PdfContent
  def initialize(url, session: Capybara.current_session)
    self.url = url
    self.session = session
  end

  def has_selector?(*args)
    assert_selector(*args)
  rescue Capybara::ExpectationNotMet
    return false
  end

  def assert_selector(selector_type, selector, options = {})
    raise "Only the :field type is currently supported in #{self.class}#assert_selector" unless selector_type == :field
    query = Capybara::Queries::SelectorQuery.new(selector_type, selector, options)
    result = all(selector_type, selector, options)
    unless result.matches_count? && ((!result.empty?) || query.expects_none?)
      raise Capybara::ExpectationNotMet, result.failure_message
    end
    true
  end

  private

  attr_accessor :url, :session

  def pdf_file
    @pdf_file ||= Tempfile.new.tap do |f|
      f.write pdf_response.body.force_encoding('UTF-8')
      f.close
    end
  end

  def pdf_fields
    @pdf_fields ||= PdfForms.new('pdftk').read(pdf_file.path).fields
  end

  def pdf_response
    @pdf_response ||= HTTParty.get url
  end

  def all(selector_type, selector, options)
    raise "Only the :field type is currently supported in #{self.class}#all" unless selector_type == :field
    results = pdf_fields.select do |field|
      field.name == selector
    end
    query = Capybara::Queries::SelectorQuery.new(selector_type, selector, options)
    Capybara::Result.new(wrap_fields(results), query)
  end

  def wrap_fields(fields)
    fields.map do |field|
      wrapped_field = PdfField.new(field)
      Capybara::Node::Element.new(session, wrapped_field, nil, nil)
    end
  end

end

class PdfField
  delegate :name, to: :pdf_field

  def initialize(pdf_field)
    self.pdf_field = pdf_field
  end

  def disabled?
    false
  end

  def visible_text
    value
  end

  def value
    pdf_field.value || ''
  end

  def method_missing(method, *args)
    super
  end

  private

  attr_accessor :pdf_field
end
