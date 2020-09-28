require_relative './base_page'
module ET1
  module Test
    class ResetMemorableWordEmailInstructionsPage < BasePage

      def using(email_address:, claim_number: nil)
        fieldset.email_address_element.set(email_address)
        fieldset.claim_number_element.set(claim_number) unless claim_number.nil?
        fieldset.submit_button.click
        ReturnToYourClaimPage.new
      end

      private

      section :fieldset, :xpath, XPath.generate { |x| x.descendant(:fieldset)[x.child(:legend)[x.string.n.is('Enter your details below')]] } do
        element :email_address_element, :fillable_field, "Enter your email address"
        element :claim_number_element, :fillable_field, "Save and return number"
        element :submit_button, :button, 'Reset memorable word'
      end
    end
  end
end
