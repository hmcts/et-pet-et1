require_relative './base_page'
module ET1
  module Test
    class StepTwoPage < BasePage

      section :about_the_claimant, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About the claimant")]] }) do
        element :title_select, 'select[name="claimant[title]"]'
        element :first_name, 'input[name="claimant[first_name]"]'
        element :last_name, 'input[name="claimant[last_name]"]'
        section :date_of_birth, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Date of birth (optional)")]] }) do
          element :day, 'input[name="claimant[date_of_birth][day]"]'
          element :month, 'input[name="claimant[date_of_birth][month]"]'
          element :year, 'input[name="claimant[date_of_birth][year]"]'
          def set(value)
            (day_value, month_value, year_value) = value.split("/")
            day.set(day_value)
            month.set(month_value)
            year.set(year_value)
          end
        end
        section :gender, "div.claimant_gender" do
          element :male, 'input[value="male"]'
          element :female, 'input[value="female"]'
          element :prefer_not_to_say, 'input[value="prefer_not_to_say"]'
          def set(value)
            choose(value, name: 'claimant[gender]')
          end
        end

        section :has_special_needs, "div.claimant_has_special_needs" do
          element :yes, 'input[value="true"]'
          element :no, 'input[value="false"]'
          def set(value)
            choose(value, name: 'claimant[has_special_needs]')
          end
        end
        element :special_needs, 'textarea[name="claimant[special_needs]"]'
      end

      section :claimants_contact_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant’s contact details")]] }) do
        element :building, 'input[name="claimant[address_building]"]'
        element :street, 'input[name="claimant[address_street]"]'
        element :locality, 'input[name="claimant[address_locality]"]'
        element :county, 'input[name="claimant[address_county]"]'
        element :post_code, 'input[name="claimant[address_post_code]"]'
        element :country, 'select[name="claimant[address_country]"]'
        element :telephone_number, 'input[name="claimant[address_telephone_number]"]'
        element :alternative_telephone_number, 'input[name="claimant[mobile_number]"]'
        element :email_address, 'input[name="claimant[email_address]"]'
        section :correspondence, '.claimant_contact_preference' do
          def set(value)
            choose(value, name: 'claimant[contact_preference]')
          end
        end

      end
      element :save_and_continue, 'form.edit_claimant input[value="Save and continue"]'
    end
    # rubocop:enable Metrics/BlockLength

  end
end
