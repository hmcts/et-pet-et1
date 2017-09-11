class StepTenPage < BasePage

  section :preferred_outcome, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Choose your preferred outcome(s)")]] }) do
    element :notes, 'textarea[name="claim_outcome[other_outcome]"]'
    def set(value)
      check value
    end
  end

  element :save_and_continue, 'form.edit_claim_outcome input[value="Save and continue"]'
end
