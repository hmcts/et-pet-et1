require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class ApplicantPage < BasePage
        section :form_error_message, '[aria-describedby=error-message]' do |section|

        end
        section :has_name_changed, ET1::Test::RefundSections::FormBoolean, :simple_form_boolean, 'Has your name changed since you made your employment tribunal claim ?'

        section :about_the_claimant, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About you")]] }) do
          section :title, ET1::Test::RefundSections::FormSelect, :simple_form_field, 'Title'
          section :first_name, ET1::Test::RefundSections::FormInput, :simple_form_field, 'First name'
          section :last_name, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Last name'
          section :date_of_birth, ET1::Test::RefundSections::FormDate, :simple_form_date, 'Date of birth'
        end

        section :claimants_contact_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.child(:legend)[x.string.n.is("Your contact details")]] }) do
          section :building, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Building number or name'
          section :street, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Street'
          section :locality, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Town/city'
          section :county, ET1::Test::RefundSections::FormInput, :simple_form_field, 'County'
          section :post_code, ET1::Test::RefundSections::FormInput, :simple_form_field, 'UK Postcode'
          section :telephone_number, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Phone or mobile number'
          section :email_address, ET1::Test::RefundSections::FormInput, :simple_form_field, 'Email address'
        end
        element :save_and_continue, 'form.edit_refunds_applicant input[value="Continue"]'
      end
    end

  end
end
