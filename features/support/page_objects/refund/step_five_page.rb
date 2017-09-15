module Refunds
  class StepFivePage < BasePage
    set_url "/apply/refund/bank-details"
    section :bank_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your Bank Details")]]}) do
      element :account_name, 'input[name="refunds_bank_details[payment_account_name]"]'
      element :bank_name, 'input[name="refunds_bank_details[payment_bank_name]"]'
      element :account_number, 'input[name="refunds_bank_details[payment_account_number]"]'
      element :sort_code, 'input[name="refunds_bank_details[payment_sort_code]"]'
    end
    element :save_and_continue, 'form.edit_refunds_bank_details input[value="Save and continue"]'
  end
end
