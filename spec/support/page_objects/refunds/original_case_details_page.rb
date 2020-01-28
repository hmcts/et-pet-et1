require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class OriginalCaseDetailsPage < BasePage
        section :original_case_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your case details")]] }) do
          section :et_country_of_claim, ET1::Test::RefundSections::FormSelect, :simple_form_field, 'Where was your claim issued?'
          section :et_case_number, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Employment tribunal case number'
          section :eat_case_number, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Employment appeal tribunal case number'
          section :et_tribunal_office, ET1::Test::RefundSections::FormSelect, :simple_form_field, 'Employment tribunal office'
          section :additional_information, ET1::Test::RefundSections::FormTextArea, :simple_form_field, 'Additional information'
        end
        section :original_claimant_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your address at the time of your claim")]] }) do
          section :building, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Building number or name'
          section :street, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Street'
          section :locality, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Town/city'
          section :county, ET1::Test::RefundSections::FormInput, :simple_form_field, 'County'
          section :post_code, ET1::Test::RefundSections::FormInput, :simple_form_field, 'UK Postcode'
          section :telephone_number, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Phone or mobile number'
          section :email_address, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Email address'
        end
        section :original_respondent_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Respondent")]] }) do
          section :name, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Respondent name'
          section :building, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Building number or name'
          section :street, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Street'
          section :locality, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Town/city'
          section :county, ET1::Test::RefundSections::FormInput, :simple_form_field, 'County'
          section :post_code, ET1::Test::RefundSections::FormInput, :simple_form_field, 'UK Postcode'
        end
        section :claim_had_representative, ET1::Test::RefundSections::FormBoolean, :simple_form_boolean, 'Did you have a representative at the time of your original claim ?'
        section :original_representative_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Representative")]] }) do
          section :name, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Representative name'
          section :building, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Building number or name'
          section :street, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Street'
          section :locality, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Town/city'
          section :county, ET1::Test::RefundSections::FormInput, :simple_form_field, 'County'
          section :post_code, ET1::Test::RefundSections::FormInput, :simple_form_field, 'UK Postcode'
        end
        section :address_changed, ET1::Test::RefundSections::FormBoolean, :simple_form_boolean, "Has your address changed since you made your employment tribunal claim ?"
        element :save_and_continue, 'form.edit_refunds_original_case_details input[value="Continue"]'
      end
    end

  end
end
