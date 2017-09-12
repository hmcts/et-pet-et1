module Refunds
  class ProfileSelectionPage < BasePage
    section :select_profile, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Please select a profile")]]}) do
      def set(value)
        choose(value)
      end
    end
    element :save_and_continue, 'input[value="Save and continue"]'
  end

end
