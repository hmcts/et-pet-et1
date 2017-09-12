module Refunds
  class StepFourPage < BasePage
    section :original_case_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Original Case Details")]]}) do
      element :et_reference_number, 'input[name="refunds_original_case_details[et_reference_number]"]'
      element :et_case_number, 'input[name="refunds_original_case_details[et_case_number]"]'
      element :et_tribunal_office, 'input[name="refunds_original_case_details[et_tribunal_office]"]'
      element :extra_reference_numbers, 'textarea[name="refunds_original_case_details[extra_reference_numbers]"]'
    end
    section :original_respondent_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Respondent")]]}) do
      element :name, 'input[name="refunds_original_case_details[respondent_name]"]'
      element :post_code, 'input[name="refunds_original_case_details[respondent_post_code]"]'
    end
    section :original_claimant_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant")]]}) do
      element :name, 'input[name="refunds_original_case_details[claimant_name]"]'
      element :post_code, 'input[name="refunds_original_case_details[claimant_address_post_code]"]'
    end
    section :original_claim_fees, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant Fees")]]}) do
      section :et_issue, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("ET Issue Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[et_issue_fee]"]'
        element :date_paid, 'input[name="refunds_original_case_details[et_issue_fee_date_paid]"]'
        element :payment_method, 'select[name="refunds_original_case_details[et_issue_fee_payment_method]"]'
      end
      section :et_hearing, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("ET Hearing Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[et_hearing_fee]"]'
        element :date_paid, 'input[name="refunds_original_case_details[et_hearing_fee_date_paid]"]'
        element :payment_method, 'select[name="refunds_original_case_details[et_hearing_fee_payment_mwethod]"]'
      end
      section :eat_lodgement, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("EAT Lodgement Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[eat_lodgement_fee]"]'
        element :date_paid, 'input[name="refunds_original_case_details[eat_lodgement_fee_date_paid]"]'
        element :payment_method, 'select[name="refunds_original_case_details[eat_lodgement_fee_payment_method]"]'
      end
      section :eat_hearing, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("EAT hearing Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[eat_hearing_fee]"]'
        element :date_paid, 'input[name="refunds_original_case_details[eat_hearing_fee_date_paid]"]'
        element :payment_method, 'select[name="refunds_original_case_details[eat_hearing_fee_payment_method]"]'
      end
      section :app_reconsideration, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Application Reconsideration Fee")]]}) do
        element :fee, 'input[name="refunds_original_case_details[app_reconsideration_fee]"]'
        element :date_paid, 'input[name="refunds_original_case_details[app_reconsideration_fee_date_paid]"]'
        element :payment_method, 'input[name="refunds_original_case_details[app_reconsideration_fee_payment_method]"]'
      end
    end
    section :address_same_as_applicant, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Address is the same as above ?")]]}) do
      def set(value)
        choose(value)
      end
    end
    element :save_and_continue, 'form.edit_refunds_claimant input[value="Save and continue"]'
  end
end
