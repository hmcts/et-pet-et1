module Refunds
  class StepFourPage < BasePage
    section :original_case_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Original Case Details")]]}) do
      element :et_case_number, 'input[name="refunds_original_case_details[et_case_number]"]'
      element :et_tribunal_office, 'input[name="refunds_original_case_details[et_tribunal_office]"]'
      element :additional_information, 'textarea[name="refunds_original_case_details[additional_information]"]'
    end
    section :original_respondent_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Respondent")]]}) do
      element :name, 'input[name="refunds_original_case_details[respondent_name]"]'
      element :post_code, 'input[name="refunds_original_case_details[respondent_post_code]"]'
    end
    section :original_representative_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Representative")]]}) do
      element :name, 'input[name="refunds_original_case_details[representative_name]"]'
      element :post_code, 'input[name="refunds_original_case_details[representative_post_code]"]'
    end
    section :original_claim_fees, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant Fees")]]}) do
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
    section :address_same_as_applicant, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Address is the same as above ?")]]}) do
      def set(value)
        choose(value)
      end
    end
    element :save_and_continue, 'form.edit_refunds_claimant input[value="Save and continue"]'
  end
end
