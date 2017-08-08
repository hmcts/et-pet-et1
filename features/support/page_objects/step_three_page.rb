class StepThreePage < BasePage

  section :group_claims, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("People making a claim with you")]]}) do
    def set(value)
      choose(value, name: "additional_claimants[of_collection_type]")
    end
    section :about_claimant_two, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant 2")]]}) do
      element :title, 'select[name="additional_claimants[collection_attributes][0][title]"]'
      element :first_name, 'input[name="additional_claimants[collection_attributes][0][first_name]"]'
      element :last_name, 'input[name="additional_claimants[collection_attributes][0][last_name]"]'
      section :date_of_birth, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Date of birth")]]}) do
        element :day, 'input[name="additional_claimants[collection_attributes][0][date_of_birth][day]"]'
        element :month, 'input[name="additional_claimants[collection_attributes][0][date_of_birth][month]"]'
        element :year, 'input[name="additional_claimants[collection_attributes][0][date_of_birth][year]"]'
        def set(value)
          (day_value, month_value, year_value) = value.split("/")
          day.set(day_value)
          month.set(month_value)
          year.set(year_value)
        end
      end
      element :building, 'input[name="additional_claimants[collection_attributes][0][address_building]"]'
      element :street, 'input[name="additional_claimants[collection_attributes][0][address_street]"]'
      element :locality, 'input[name="additional_claimants[collection_attributes][0][address_locality]"]'
      element :county, 'input[name="additional_claimants[collection_attributes][0][address_county]"]'
      element :post_code, 'input[name="additional_claimants[collection_attributes][0][address_post_code]"]'

    end

  end
  element :save_and_continue, 'form.edit_additional_claimants input[value="Save and continue"]'
end
