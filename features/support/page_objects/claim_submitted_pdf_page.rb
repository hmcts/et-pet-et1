class ClaimSubmittedPdfPage < BasePage
  set_url "/uploads/claim/pdf{/p1}{/p2}"

  # This is a fake section which makes the pdf content matchable using normal capybara methods
  # even though pdf is nothing like html
  def pdf_content
    @pdf_content ||= PdfContent.new(current_url)
  end

  def find(*args)
    return super unless args.first == :pdf_document
    @pdf_document ||= Capybara::Node::Element.new Capybara.current_session, PdfDocument.new(current_url), nil, nil
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
    section :respondents_details, :pdf_fieldset, :respondents_details do
      section :name, :pdf_fieldset, :name do
        element :name, :pdf_field_named, '2.1'
      end
      section :address, :pdf_fieldset, :address do
        element :building, :pdf_field_named, '2.2 number'
        element :street, :pdf_field_named, '2.2 street'
        element :locality, :pdf_field_named, '2.2 town city'
        element :county, :pdf_field_named, '2.2 county'
        element :post_code, :pdf_field_named, '2.2 postcode'
        element :telephone_number, :pdf_field_named, '2.2 phone number'
      end

      section :acas, :pdf_fieldset, :acas do
        element :have_acas, :pdf_field_named, 'Check Box1'
        element :acas_number, :pdf_field_named, 'Text2'
      end

      section :different_address, :pdf_fieldset, :different_address do
        element :building, :pdf_field_named, '2.3 number'
        element :street, :pdf_field_named, '2.3 street'
        element :locality, :pdf_field_named, '2.3 town city'
        element :county, :pdf_field_named, '2.3 county'
        element :post_code, :pdf_field_named, '2.3 postcode'
        element :telephone_number, :pdf_field_named, '2.3 phone number'
      end

      section :respondent_two, :pdf_fieldset, :respondent_two do
        section :name, :pdf_fieldset, :name do
          element :name, :pdf_field_named, '2.4 R2 name'
        end
        section :address, :pdf_fieldset, :address do
          element :building, :pdf_field_named, '2.4 R2 number'
          element :street, :pdf_field_named, '2.4 R2 street'
          element :locality, :pdf_field_named, '2.4 R2 town'
          element :county, :pdf_field_named, '2.4 R2 county'
          element :post_code, :pdf_field_named, '2.4 R2 postcode'
          element :telephone_number, :pdf_field_named, '2.4 R2 phone number'
        end

        section :acas, :pdf_fieldset, :acas do
          element :have_acas, :pdf_field_named, 'Check Box8'
          element :acas_number, :pdf_field_named, 'Text9'
        end
      end

      section :respondent_three, :pdf_fieldset, :respondent_three do
        section :name, :pdf_fieldset, :name do
          element :name, :pdf_field_named, '2.4 R3 name'
        end
        section :address, :pdf_fieldset, :address do
          element :building, :pdf_field_named, '2.4 R3 number'
          element :street, :pdf_field_named, '2.4 R3 street'
          element :locality, :pdf_field_named, '2.4 R3 town city'
          element :county, :pdf_field_named, '2.4 R3 county'
          element :post_code, :pdf_field_named, '2.4 R3 postcode'
          element :telephone_number, :pdf_field_named, '2.4 R3 phone number'
        end

        section :acas, :pdf_fieldset, :acas do
          element :have_acas, :pdf_field_named, 'Check Box15'
          element :acas_number, :pdf_field_named, 'Text16'
        end
      end
    end
    section :multiple_cases, :pdf_fieldset, :multiple_cases do
      section :have_similar_claims, :pdf_field_named, '3.1 tick boxes' do
        def value
          root_element.value.titleize
        end
      end
      element :other_claimants, :pdf_field_named, '3.1 if yes'
    end
    section :respondent_not_your_employer, :pdf_fieldset, :respondent_not_your_employer do
      element :claim_type, :pdf_field_named, '4.1'
    end
    section :employment_details, :pdf_fieldset, :employment_details do
      element :job_title, :pdf_field_named, '5.2'
      element :start_date, :pdf_field_named, '5.1 employment start'
      section :employment_continuing, :pdf_field_named, '5.1 tick boxes' do
        def value
          root_element.value.titleize
        end
      end
      element :ended_date, :pdf_field_named, '5.1 employment end'
      element :ending_date, :pdf_field_named, '5.1 not ended'
    end
    section :earnings_and_benefits, :pdf_fieldset, :earnings_and_benefits do
      element :average_weekly_hours, :pdf_field_named, '6.1'
      section :pay_before_tax, :pdf_fieldset, :pay_before_tax do
        element :amount, :pdf_field_named, '6.2 pay before tax'
        element :period, :pdf_field_named, '6.2 pay before tax tick boxes'
        def value
          "#{amount.value} #{period.value.titleize}"
        end
      end
      section :pay_after_tax, :pdf_fieldset, :pay_after_tax do
        element :amount, :pdf_field_named, '6.2 normal pay'
        element :period, :pdf_field_named, '6.2 normal pay tick boxes'
        def value
          "#{amount.value} #{period.value.titleize}"
        end
      end
      section :paid_for_notice_period, :pdf_field_named, '6.3 tick boxes' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :notice_period, :pdf_fieldset, :notice_period do
        element :weeks, :pdf_field_named, '6.3 weeks'
        element :months, :pdf_field_named, '6.3 months'
        def value
          if weeks.value.present?
            "#{weeks.value} Weeks"
          elsif months.value.present?
            "#{months.value} Months"
          else
            ''
          end
        end
      end
      section :employers_pension_scheme, :pdf_field_named, '6.4 tick boxes' do
        def value
          root_element.value.titleize
        end
      end
      element :benefits, :pdf_field_named, '6.5'
    end

    section :what_happened_since, :pdf_fieldset, :what_happened_since do
      section :have_another_job, :pdf_field_named, '7.1 tick boxes' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      element :start_date, :pdf_field_named, '7.2'
      element :salary, :pdf_field_named, '7.3'
    end

    section :type_and_details_of_claim, :pdf_fieldset, :type_and_details_of_claim do
      section :unfairly_dismissed, :pdf_field_named, '8.1 unfairly tick box' do
        def value
          root_element.value.titleize
        end
      end
      section :discriminated_age, :pdf_field_named, '8.1 age' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_race, :pdf_field_named, '8.1 race' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_gender_reassignment, :pdf_field_named, '8.1 gender reassignment' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_disability, :pdf_field_named, '8.1 disability' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_pregnancy, :pdf_field_named, '8.1 pregnancy' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_marriage, :pdf_field_named, '8.1 marriage' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_sexual_orientation, :pdf_field_named, '8.1 sexual orientation' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_sex, :pdf_field_named, '8.1 sex' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :discriminated_religion, :pdf_field_named, '8.1 religion' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :claiming_redundancy_payment, :pdf_field_named, '8.1 redundancy' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :owed_notice_pay, :pdf_field_named, '8.1 notice pay' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :owed_holiday_pay, :pdf_field_named, '8.1 holiday pay' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :owed_arrears_of_pay, :pdf_field_named, '8.1 arrears of pay' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :owed_other_payments, :pdf_field_named, '8.1 other payments' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :other_type_of_claim, :pdf_field_named, '8.1 another type of claim' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      element :other_type_of_claim_details, :pdf_field_named, '8.1 other type of claim'
      element :claim_description, :pdf_field_named, '8.2'

    end
    section :what_do_you_want, :pdf_fieldset, :what_do_you_want do
      section :prefer_re_instatement, :pdf_field_named, '9.1 old job back' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :prefer_re_engagement, :pdf_field_named, '9.1 another job' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      section :prefer_compensation, :pdf_field_named, '9.1 compensation' do
        def value
          root_element.value.titleize
        end
      end
      section :prefer_recommendation, :pdf_field_named, '9.1 recommendation' do
        def value
          case root_element.value.downcase
          when 'off' then 'No'
          when 'on' then 'Yes'
          else ''
          end
        end
      end
      element :compensation, :pdf_field_named, '9.2'

    end
    section :information_to_regulators, :pdf_fieldset, :information_to_regulators do
      section :whistle_blowing, :pdf_field_named, '10.1' do
        def value
          root_element.value.titleize
        end
      end
    end
    section :your_representative, :pdf_fieldset, :your_representative do
      element :name_of_representative, :pdf_field_named, '11.1'
      element :name_of_organisation, :pdf_field_named, '11.2'
      element :building, :pdf_field_named, '11.3 number'
      element :street, :pdf_field_named, '11.3 street'
      element :locality, :pdf_field_named, '11.3 town city'
      element :county, :pdf_field_named, '11.3 county'
      element :post_code, :pdf_field_named, '11.3 postcode'
      element :dx_number, :pdf_field_named, '11.4 dx number'
      element :telephone_number, :pdf_field_named, '11.5 phone number'
      element :alternative_telephone_number, :pdf_field_named, '11.6 mobile number'
      element :reference, :pdf_field_named, '11.7 reference'
      element :email_address, :pdf_field_named, '11.8 email'
      section :communication_preference, :pdf_field_named, '11.9 tick boxes' do
        def value
          v = root_element.value.titleize
          case v
          when "Off" then ""
          else v
          end
        end
      end
      element :fax_number, :pdf_field_named, '11.10 fax number'
    end
    section :disability, :pdf_fieldset, :disability do
      section :has_special_needs, :pdf_field_named, '12.1 tick box' do
        def value
          root_element.value.titleize
        end
      end
      element :special_needs, :pdf_field_named, '12.1 if yes'
    end
    section :additional_respondents, :pdf_fieldset, :additional_respondents do
      section :respondent_four, :pdf_fieldset, :respondent_four do
        element :name, :pdf_field_named, '13 R4 name'
        element :building, :pdf_field_named, '13 R4 number'
        element :street, :pdf_field_named, '13 R4 street'
        element :locality, :pdf_field_named, '13 R4 town city'
        element :county, :pdf_field_named, '13 R4 county'
        element :post_code, :pdf_field_named, '13 R4 postcode'
        element :telephone_number, :pdf_field_named, '13 R4 phone number'
        element :have_acas, :pdf_field_named, 'Check Box22'
        element :acas_number, :pdf_field_named, 'Text23'
      end
      section :respondent_five, :pdf_fieldset, :respondent_four do
        element :name, :pdf_field_named, '13 R5 name'
        element :building, :pdf_field_named, '13 R5 number'
        element :street, :pdf_field_named, 'R5 street'
        element :locality, :pdf_field_named, 'R5 town city'
        element :county, :pdf_field_named, 'R5 county'
        element :post_code, :pdf_field_named, 'R5 postcode'
        element :telephone_number, :pdf_field_named, 'R5 phone number'
        element :have_acas, :pdf_field_named, 'Check Box29'
        element :acas_number, :pdf_field_named, 'Text30'
      end
    end
    section :final_check, :pdf_fieldset, :final_check do
      section :satisfied, :pdf_field_named, '14 satisfied tick box' do
        def value
          case root_element.value.downcase
          when 'yes' then 'Yes'
          else 'No'
          end
        end
      end
    end
    section :additional_information, :pdf_fieldset, :additional_information do
      element :additional_information, :pdf_field_named, '15'
    end
  end

end
class PdfDocument
  def initialize(url)
    self.pdf_content = PdfContent.new(url)
  end

  def find_xpath(*args)
    raise "only //fieldsetdf[id=xxx] is supported" unless args.first.start_with?('//fieldset')
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

  def visible?
    true
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

  def find(selector_type, selector, _options = {})
    raise "Only supports xpath" unless selector_type == :xpath
    raise "invalid xpath selector '#{selector}' Only supports xpath eg //field[@name=xxxx]" unless selector.start_with?('//field[@name=')
    field_name = selector.match(%r{^\/\/field\[@name=(.*)\]$})[1]
    result = pdf_fields.find do |field|
      field.name == field_name
    end
    raise Capybara::ElementNotFound, "Cannot find pdf_field '#{selector}'" if result.nil?
    wrap_field(result)
  end

  def assert_selector(selector_type, selector, options = {})
    raise "Only the :field type is currently supported in #{self.class}#assert_selector" unless selector_type == :field
    query = Capybara::Queries::SelectorQuery.new(selector_type, selector, options)
    result = all(selector_type, selector, options)
    unless result.matches_count? && (!result.empty? || query.expects_none?)
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

  def visible?
    true
  end

  private

  attr_accessor :pdf_field
end
# rubocop:enable Metrics/BlockLength, Metrics/ClassLength

Capybara::Selector.add :pdf_document do
  xpath do
    '//pdf_document'
  end
end
Capybara::Selector.add :pdf_fieldset do
  xpath do |fieldset_id|
    "//fieldset[@id=#{fieldset_id}]"
  end
end
Capybara::Selector.add :pdf_field_named do
  xpath do |field_name|
    "//field[@name=#{field_name}]"
  end
end
