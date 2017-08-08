class StepFivePage < BasePage

  section :about_the_respondent, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("About the respondent")]]}) do
    element :name, 'input[name="respondent[name]"]'
    element :building, 'input[name="respondent[address_building]"]'
    element :street, 'input[name="respondent[address_street]"]'
    element :locality, 'input[name="respondent[address_locality]"]'
    element :county, 'input[name="respondent[address_county]"]'
    element :post_code, 'input[name="respondent[address_post_code]"]'
    element :telephone_number, 'input[name="respondent[address_telephone_number]"]'
  end
  section :your_work_address, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your work address")]]}) do
    element :building, 'input[name="respondent[work_address_building]"]'
    element :street, 'input[name="respondent[work_address_street]"]'
    element :locality, 'input[name="respondent[work_address_locality]"]'
    element :county, 'input[name="respondent[work_address_county]"]'
    element :post_code, 'input[name="respondent[work_address_post_code]"]'
    element :telephone_number, 'input[name="respondent[work_address_telephone_number]"]'
    section :same_address, '.respondent_worked_at_same_address' do
      def set(value)
        choose value, name: 'respondent[worked_at_same_address]'
      end
    end
  end
  section :acas, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Acas early conciliation certificate number")]]}) do
    element :certificate_number, 'input[name="respondent[acas_early_conciliation_certificate_number]"]'
  end
  element :save_and_continue, 'form.edit_respondent input[value="Save and continue"]'
end
