module Refunds
  class ReviewPage < BasePage
    section :declaration, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Declaration")]]}) do
      element :accept, 'I confirm the above'
      def set(value)
        within @root_element do
          check 'refunds_review[accept_declaration]' if value == 'Yes'
          uncheck 'refunds_review[accept_declaration]' if value == 'No'
        end
      end
    end
    element :save_and_continue, 'form.edit_refunds_review input[value="Submit Claim"]'
  end
end
