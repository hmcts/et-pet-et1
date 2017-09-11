class StepElevenPage < BasePage

  section :other_important_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Other important details")]] }) do
    element :notes, 'textarea[name="additional_information[miscellaneous_information]"]'
    def set(value)
      choose value, name: "additional_information[has_miscellaneous_information]"
    end
  end

  element :save_and_continue, 'form.edit_additional_information input[value="Save and continue"]'
end
