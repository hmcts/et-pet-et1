class ClaimSubmittedPdfPage < BasePage
  set_url "/uploads/claim/pdf{/p1}{/p2}"

  # This is a fake section which makes the pdf content matchable using normal capybara methods
  # even though pdf is nothing like html
  def pdf_content
    @pdf_content ||= PdfContent.new(current_url)
  end


  def find(*args)
    return super unless args.first == :pdf_document
    Capybara::Node::Element.new Capybara.current_session, PdfDocument.new(current_url), nil, nil
  end

  section :pdf_document, :pdf_document, :current_url do
    section :your_details, :pdf_fieldset, :your_details do
      section :title, :pdf_field_named, '1.1 title tick boxes' do
        def value
          root_element.value.titleize
        end
      end
      element :first_name, :pdf_field_named, '1.2 first names'
      element :last_name, :pdf_field_named, '1.3 surname'
      section :date_of_birth, :pdf_fieldset, :date_of_birth do
        element :dob_day, :pdf_field_named, '1.4 DOB day'
        element :dob_month, :pdf_field_named, '1.4 DOB month'
        element :dob_year, :pdf_field_named, '1.4 DOB year'
        def value
          "#{dob_day.value}/#{dob_month.value}/#{dob_year.value}"
        end
      end
      section :gender, :pdf_field_named, '1.4 gender' do
        def value
          root_element.value.titleize
        end
      end
      element :building, :pdf_field_named, '1.5 number'
      element :street, :pdf_field_named, '1.5 street'
      element :locality, :pdf_field_named, '1.5 town city'
      element :county, :pdf_field_named, '1.5 county'
      element :post_code, :pdf_field_named, '1.5 postcode'
      element :telephone_number, :pdf_field_named, '1.6 phone number'
      element :alternative_telephone_number, :pdf_field_named, '1.7 mobile number'
      element :email_address, :pdf_field_named, '1.9 email'
      section :correspondence, :pdf_field_named, '1.8 tick boxes' do
        def value
          root_element.value.titleize
        end
      end
    end
  end

end
class PdfDocument
  def initialize(url)
    self.pdf_content = PdfContent.new(url)
  end

  def find_xpath(*args)
    raise "only //fieldset[id=xxx] is supported" unless args.first.start_with?('//fieldset')
    [PdfFieldSet.new(pdf_content, args.first)]
  end

  private

  attr_accessor :pdf_content
end
class PdfFieldSet
  def initialize(pdf_content, fieldset_root)
    self.pdf_content = pdf_content
    self.root = fieldset_root
  end
  def find_xpath(*args)
    return [self.class.new(pdf_content, args.first)] if args.first.start_with?('//fieldset')
    [pdf_content.find(:xpath, args.first)]
  end

  private

  attr_accessor :root, :pdf_content
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

  def find(selector_type, selector, options = {})
    raise "Only supports xpath" unless selector_type == :xpath
    raise "invalid xpath selector '#{selector}' Only supports xpath eg //field[@name=xxxx]" unless selector.start_with?('//field[@name=')
    field_name = selector.match(/^\/\/field\[@name=(.*)\]$/)[1]
    result = pdf_fields.find do |field|
      field.name == field_name
    end
    raise Capybara::ElementNotFound.new "Cannot find pdf_field '#{selector}'" if result.nil?
    wrap_field(result)
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
      wrap_field(field)
    end
  end

  def wrap_field(field)
    wrapped_field = PdfField.new(field)
    Capybara::Node::Element.new(session, wrapped_field, nil, nil)
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

  private

  attr_accessor :pdf_field
end

Capybara::Selector.add :pdf_document do
  xpath do
    '//pdf_document'
  end
end
Capybara::Selector.add :pdf_fieldset do
  xpath do | fieldset_id |
    "//fieldset[@id=#{fieldset_id}]"
  end
end
Capybara::Selector.add :pdf_field_named do
  xpath do | field_name |
    "//field[@name=#{field_name}]"
  end
end
