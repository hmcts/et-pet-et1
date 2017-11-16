class StepSixPage < BasePage

  section :more_than_one_employer, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claims against more than one employer")]] }) do
    def set(value)
      choose value, name: "additional_respondents[of_collection_type]"
    end
    (2..5).each_with_index do |number, idx|
      section :"respondent_#{number}", :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Respondent #{idx + 2}")]] }) do |*_args|
        element :name, "input[name=\"additional_respondents[collection_attributes][#{idx}][name]\"]"
        element :building, "input[name=\"additional_respondents[collection_attributes][#{idx}][address_building]\"]"
        element :street, "input[name=\"additional_respondents[collection_attributes][#{idx}][address_street]\"]"
        element :locality, "input[name=\"additional_respondents[collection_attributes][#{idx}][address_locality]\"]"
        element :county, "input[name=\"additional_respondents[collection_attributes][#{idx}][address_county]\"]"
        element :post_code, "input[name=\"additional_respondents[collection_attributes][#{idx}][address_post_code]\"]"
        element :telephone_number, "input[name=\"additional_respondents[collection_attributes][#{idx}][address_telephone_number]\"]"
        element :acas_number, "input[name=\"additional_respondents[collection_attributes][#{idx}][acas_early_conciliation_certificate_number]\"]"
      end
    end
    element :add_another_respondent, 'input[value="Add another respondent"]'
  end
  element :save_and_continue, 'form.edit_additional_respondents input[value="Save and continue"]'
end
