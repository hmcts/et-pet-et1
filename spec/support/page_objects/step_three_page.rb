require_relative './base_page'
module ET1
  module Test
    class StepThreePage < BasePage

      section :group_claims, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("People making a claim with you")]] }) do
        def set(value)
          choose(value, name: "additional_claimants[of_collection_type]")
        end
        ['two', 'three', 'four', 'five', 'six'].each_with_index do |number, idx|

          section :"about_claimant_#{number}", :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant #{idx + 2}")]] }) do
            element :title_select, "select[name=\"additional_claimants[collection_attributes][#{idx}][title]\"]"
            element :first_name, "input[name=\"additional_claimants[collection_attributes][#{idx}][first_name]\"]"
            element :last_name, "input[name=\"additional_claimants[collection_attributes][#{idx}][last_name]\"]"
            section :date_of_birth, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Date of birth (optional)")]] }) do
              element :day, "input[name=\"additional_claimants[collection_attributes][#{idx}][date_of_birth][day]\"]"
              element :month, "input[name=\"additional_claimants[collection_attributes][#{idx}][date_of_birth][month]\"]"
              element :year, "input[name=\"additional_claimants[collection_attributes][#{idx}][date_of_birth][year]\"]"
              def set(value)
                (day_value, month_value, year_value) = value.split("/")
                day.set(day_value)
                month.set(month_value)
                year.set(year_value)
              end
            end
            element :building, "input[name=\"additional_claimants[collection_attributes][#{idx}][address_building]\"]"
            element :street, "input[name=\"additional_claimants[collection_attributes][#{idx}][address_street]\"]"
            element :locality, "input[name=\"additional_claimants[collection_attributes][#{idx}][address_locality]\"]"
            element :county, "input[name=\"additional_claimants[collection_attributes][#{idx}][address_county]\"]"
            element :post_code, "input[name=\"additional_claimants[collection_attributes][#{idx}][address_post_code]\"]"

          end
        end
        element :add_more_claimants, 'input[value="Add more claimants"]'
      end
      element :save_and_continue, 'form.edit_additional_claimants input[value="Save and continue"]'
    end
    # rubocop:enable Metrics/BlockLength

  end
end
