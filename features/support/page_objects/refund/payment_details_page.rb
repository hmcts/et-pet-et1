module Refunds
  class PaymentDetailsPage < BasePage
    set_url "/apply/refund/bank-details"
    section :bank_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your Bank/Building Society Details")]] }) do
      section :account_name, AppTest::FormInput, :simple_form_field, 'Account Name'
      section :bank_name, AppTest::FormInput, :simple_form_field, 'Bank/Building Society name'
      section :account_number, AppTest::FormInput, :simple_form_field, 'Account Number'
      section :sort_code, AppTest::FormInput, :simple_form_field, 'Sort Code'
    end
    element :save_and_continue, 'form.edit_refunds_bank_details input[value="Continue"]'
  end
end
