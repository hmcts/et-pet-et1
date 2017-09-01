module Refunds
  class StepTwoPage < BasePage
    section :is_claimant, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Are you the claimant ?")]]}) do
      def set(value)
        choose(value)
      end
    end

    section :has_address_changed, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Has your address changed since the original claim was made ?")]]}) do
      def set(value)
        choose(value)
      end
    end

    section :has_name_changed, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Has your name changed since the original claim was made ?")]]}) do
      def set(value)
        choose(value)
      end
    end


    section :about_the_claimant, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About the claimant")]]}) do
      element :title, 'select[name="refunds_claimant[title]"]'
      element :first_name, 'input[name="refunds_claimant[first_name]"]'
      element :last_name, 'input[name="refunds_claimant[last_name]"]'
      element :national_insurance, 'input[name="refunds_claimant[national_insurance]"]'
      section :date_of_birth, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Date of birth")]]}) do
        element :day, 'input[name="refunds_claimant[date_of_birth][day]"]'
        element :month, 'input[name="refunds_claimant[date_of_birth][month]"]'
        element :year, 'input[name="refunds_claimant[date_of_birth][year]"]'
        def set(value)
          (day_value, month_value, year_value) = value.split("/")
          day.set(day_value)
          month.set(month_value)
          year.set(year_value)
        end
      end
    end

    section :claimants_contact_details, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Claimant’s contact details")]]}) do
      element :building, 'input[name="refunds_claimant[address_building]"]'
      element :street, 'input[name="refunds_claimant[address_street]"]'
      element :locality, 'input[name="refunds_claimant[address_locality]"]'
      element :county, 'input[name="refunds_claimant[address_county]"]'
      element :post_code, 'input[name="refunds_claimant[address_post_code]"]'
      element :country, 'select[name="refunds_claimant[address_country]"]'
      element :telephone_number, 'input[name="refunds_claimant[address_telephone_number]"]'
      element :alternative_telephone_number, 'input[name="refunds_claimant[mobile_number]"]'
      element :email_address, 'input[name="refunds_claimant[email_address]"]'
    end
    element :save_and_continue, 'form.edit_refunds_claimant input[value="Save and continue"]'
  end
end
