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
      element :title, 'select[name="refunds_original_case_details[claimant_title]"]'
      element :first_name, 'input[name="refunds_original_case_details[claimant_first_name]"]'
      element :last_name, 'input[name="refunds_original_case_details[claimant_last_name]"]'
      element :national_insurance, 'input[name="refunds_original_case_details[claimant_national_insurance]"]'
      section :date_of_birth, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Date of birth")]]}) do
        element :day, 'input[name="refunds_original_case_details[claimant_date_of_birth][day]"]'
        element :month, 'input[name="refunds_original_case_details[claimant_date_of_birth][month]"]'
        element :year, 'input[name="refunds_original_case_details[claimant_date_of_birth][year]"]'
        def set(value)
          (day_value, month_value, year_value) = value.split("/")
          day.set(day_value)
          month.set(month_value)
          year.set(year_value)
        end

        def value
          [day.value, month.value, year.value].join('/')
        end

        def disabled?
          [day, month, year].all?(&:disabled?)
        end
      end
    end
    element :save_and_continue, 'form.edit_refunds_claimant input[value="Save and continue"]'
  end
end
