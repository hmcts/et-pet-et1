module Refunds
  class ReviewPage < BasePage
    section :declaration, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Declaration")]]}) do
      def set(value)
        choose(value)
      end
    end
    element :save_and_continue, 'form.edit_refunds_review input[value="Continue"]'
  end
end
