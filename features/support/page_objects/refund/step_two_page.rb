module Refunds
  class StepTwoPage < BasePage
    section :form_error_message, '[aria-describedby=error-message]' do |section|

    end
    section :is_claimant, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Are you the claimant ?")]]}) do
      def set(value)
        choose(value)
      end
    end

    section :has_name_changed, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Has your name changed since the original claim was made ?")]]}) do
      def set(value)
        choose(value)
      end
    end


    section :about_the_claimant, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About the claimant")]]}) do
      section :title, AppTest::FormSelect, :simple_form_field, 'Title'
      section :first_name, AppTest::FormInput, :simple_form_field, 'First name'
      section :last_name, AppTest::FormInput, :simple_form_field, 'Last name'
      section :date_of_birth, AppTest::FormDate, :simple_form_date, 'Date of birth'
    end

    section :claimants_contact_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant’s contact details")]]}) do
      element :building, 'input[name="refunds_applicant[address_building]"]'
      element :street, 'input[name="refunds_applicant[address_street]"]'
      element :locality, 'input[name="refunds_applicant[address_locality]"]'
      element :county, 'input[name="refunds_applicant[address_county]"]'
      element :post_code, 'input[name="refunds_applicant[address_post_code]"]'
      element :country, 'select[name="refunds_applicant[address_country]"]'
      element :telephone_number, 'input[name="refunds_applicant[address_telephone_number]"]'
      element :email_address, 'input[name="refunds_applicant[email_address]"]'
    end
    element :save_and_continue, 'form.edit_refunds_applicant input[value="Save and continue"]'
  end
end
