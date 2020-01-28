require_relative './base_page'
module ET1
  module Test
    class StepFourPage < BasePage

      section :representatives_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("The person representing you")]] }) do
        section :representative, ".representative_has_representative" do
          def set(value)
            choose(value)
          end
        end
        section :about_your_representative, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About your representative")]] }) do
          element :type, 'select[name="representative[type]"]'
          element :organisation_name, 'input[name="representative[organisation_name]"]'
          element :name, 'input[name="representative[name]"]'
        end
        section :contact_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Representative’s contact details")]] }) do
          element :building, 'input[name="representative[address_building]"]'
          element :street, 'input[name="representative[address_street]"]'
          element :locality, 'input[name="representative[address_locality]"]'
          element :county, 'input[name="representative[address_county]"]'
          element :post_code, 'input[name="representative[address_post_code]"]'
          element :country, 'select[name="representative[address_country]"]'
          element :telephone_number, 'input[name="representative[address_telephone_number]"]'
          element :alternative_telephone_number, 'input[name="representative[mobile_number]"]'
          element :email_address, 'input[name="representative[email_address]"]'
          element :dx_number, 'input[name="representative[dx_number]"]'
        end
      end
      element :save_and_continue, 'form.edit_representative input[value="Save and continue"]'
    end

  end
end
