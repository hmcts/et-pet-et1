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
      section :building, AppTest::FormInput, :simple_form_field, 'Address building'
      section :street, AppTest::FormInput, :simple_form_field, 'Address street'
      section :locality, AppTest::FormInput, :simple_form_field, 'Address locality'
      section :county, AppTest::FormInput, :simple_form_field, 'Address county'
      section :post_code, AppTest::FormInput, :simple_form_field, 'Address post code'
      section :country, AppTest::FormSelect, :simple_form_field, 'Address country'
      section :telephone_number, AppTest::FormInput, :simple_form_field, 'Address telephone number'
      section :email_address, AppTest::FormInput, :simple_form_field, 'Email'
    end
    element :save_and_continue, 'form.edit_refunds_applicant input[value="Save and continue"]'
  end
end
