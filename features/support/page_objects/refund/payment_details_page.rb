module Refunds
  class PaymentDetailsPage < BasePage
    set_url "/en/apply/refund/bank-details"
    section :account_type, AppTest::FormSelect, :simple_form_field, 'Account type'
    section :bank_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your Bank Details")]] }) do
      section :account_name, AppTest::FormInput, :simple_form_field, 'Bank account holder name'
      section :bank_name, AppTest::FormInput, :simple_form_field, 'Bank name'
      section :account_number, AppTest::FormInput, :simple_form_field, 'Bank account number'
      section :sort_code, AppTest::FormInput, :simple_form_field, 'Bank sort code'
    end
    section :building_society_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your Building Society Details")]] }) do
      section :account_name, AppTest::FormInput, :simple_form_field, 'Building Society account holder name'
      section :building_society_name, AppTest::FormInput, :simple_form_field, 'Building Society name'
      section :account_number, AppTest::FormInput, :simple_form_field, 'Building Society account number'
      section :sort_code, AppTest::FormInput, :simple_form_field, 'Building Society sort code'
    end
    element :save_and_continue, 'form.edit_refunds_bank_details input[value="Continue"]'
  end
end
