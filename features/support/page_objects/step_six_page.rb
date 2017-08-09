class StepSixPage < BasePage

  section :more_than_one_employer, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claims against more than one employer")]]}) do
    def set(value)
      choose value, name: "additional_respondents[of_collection_type]"
    end
    section :respondent_two, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Respondent 2")]]}) do
      element :name, 'input[name="additional_respondents[collection_attributes][0][name]"]'
      element :building, 'input[name="additional_respondents[collection_attributes][0][address_building]"]'
      element :street, 'input[name="additional_respondents[collection_attributes][0][address_street]"]'
      element :locality, 'input[name="additional_respondents[collection_attributes][0][address_locality]"]'
      element :county, 'input[name="additional_respondents[collection_attributes][0][address_county]"]'
      element :post_code, 'input[name="additional_respondents[collection_attributes][0][address_post_code]"]'
      element :telephone_number, 'input[name="additional_respondents[collection_attributes][0][address_telephone_number]"]'
      element :acas_number, 'input[name="additional_respondents[collection_attributes][0][acas_early_conciliation_certificate_number]"]'
    end
  end
  element :save_and_continue, 'form.edit_additional_respondents input[value="Save and continue"]'
end
