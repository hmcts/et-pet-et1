module Refunds
  class StepFivePage < BasePage
    set_url "/apply/refund/bank-details"
    element :account_type, 'select[name="refunds_bank_details[payment_account_type]"]'
    section :bank_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your Bank Details")]]}) do
      section :account_name, AppTest::FormInput, :simple_form_field, 'Bank account holder name'
      section :bank_name, AppTest::FormInput, :simple_form_field, 'Bank name'
      section :account_number, AppTest::FormInput, :simple_form_field, 'Bank account number'
      section :sort_code, AppTest::FormInput, :simple_form_field, 'Bank sort code'
    end
    section :building_society_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your Building Society Details")]]}) do
      section :account_name, AppTest::FormInput, :simple_form_field, 'Building society account holder name'
      section :bank_name, AppTest::FormInput, :simple_form_field, 'Building society name'
      section :account_number, AppTest::FormInput, :simple_form_field, 'Building society account number'
      section :sort_code, AppTest::FormInput, :simple_form_field, 'Building society sort code'
      section :reference_number, AppTest::FormInput, :simple_form_field, 'Building society roll/reference number'
    end
    element :save_and_continue, 'form.edit_refunds_bank_details input[value="Continue"]'
  end
end
