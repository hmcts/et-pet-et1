module Refunds
  class StepFourPage < BasePage
    section :original_case_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your case details")]]}) do
      element :et_case_number, 'input[name="refunds_original_case_details[et_case_number]"]'
      element :et_tribunal_office, 'input[name="refunds_original_case_details[et_tribunal_office]"]'
      element :additional_information, 'textarea[name="refunds_original_case_details[additional_information]"]'
    end
    section :original_claimant_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your address at the time of your claim")]]}) do
      section :building, AppTest::FormInput, :simple_form_field, 'Building number or name'
      section :street, AppTest::FormInput, :simple_form_field, 'Street'
      section :locality, AppTest::FormInput, :simple_form_field, 'Town/city'
      section :county, AppTest::FormInput, :simple_form_field, 'County'
      section :post_code, AppTest::FormInput, :simple_form_field, 'UK Postcode'
      section :country, AppTest::FormSelect, :simple_form_field, 'Country'
      section :telephone_number, AppTest::FormInput, :simple_form_field, 'Phone or mobile number'
      section :email_address, AppTest::FormInput, :simple_form_field, 'Email address'
    end
    section :original_respondent_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Respondent")]]}) do
      section :name, AppTest::FormInput, :simple_form_field, 'Respondent name'
      section :building, AppTest::FormInput, :simple_form_field, 'Building number or name'
      section :street, AppTest::FormInput, :simple_form_field, 'Street'
      section :locality, AppTest::FormInput, :simple_form_field, 'Town/city'
      section :county, AppTest::FormInput, :simple_form_field, 'County'
      section :post_code, AppTest::FormInput, :simple_form_field, 'UK Postcode'
      section :country, AppTest::FormSelect, :simple_form_field, 'Country'
    end
    section :original_representative_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Representative")]]}) do
      section :name, AppTest::FormInput, :simple_form_field, 'Representative name'
      section :building, AppTest::FormInput, :simple_form_field, 'Building number or name'
      section :street, AppTest::FormInput, :simple_form_field, 'Street'
      section :locality, AppTest::FormInput, :simple_form_field, 'Town/city'
      section :county, AppTest::FormInput, :simple_form_field, 'County'
      section :post_code, AppTest::FormInput, :simple_form_field, 'UK Postcode'
      section :country, AppTest::FormSelect, :simple_form_field, 'Country'
    end
    section :original_claim_fees, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About your fees paid")]]}) do
      section :et_issue, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("ET Issue Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[et_issue_fee]"]'
        element :payment_method, 'select[name="refunds_original_case_details[et_issue_fee_payment_method]"]'
      end
      section :et_hearing, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("ET Hearing Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[et_hearing_fee]"]'
        element :payment_method, 'select[name="refunds_original_case_details[et_hearing_fee_payment_method]"]'
      end
      section :eat_issue, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("EAT Issue Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[eat_issue_fee]"]'
        element :payment_method, 'select[name="refunds_original_case_details[eat_issue_fee_payment_method]"]'
      end
      section :eat_hearing, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("EAT Hearing Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[eat_hearing_fee]"]'
        element :payment_method, 'select[name="refunds_original_case_details[eat_hearing_fee_payment_method]"]'
      end
      section :app_reconsideration, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Application Reconsideration Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[app_reconsideration_fee]"]'
        element :payment_method, 'select[name="refunds_original_case_details[app_reconsideration_fee_payment_method]"]'
      end
    end
    section :address_changed, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Has your address changed since your original claim ?")]]}) do
      def set(value)
        choose(value)
      end
    end
    element :save_and_continue, 'form.edit_refunds_original_case_details input[value="Continue"]'
  end
end
