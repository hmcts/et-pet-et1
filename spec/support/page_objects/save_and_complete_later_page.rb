require_relative './base_page'
module ET1
  module Test
    class SaveAndCompleteLaterPage < BasePage

      def with(email_address:)
        email_address_element.set(email_address)
        submit_button.click
      end

      private

      element :email_address_element, :fillable_field, "Enter your email address to get your claim number emailed to you."
      element :submit_button, :button, 'Sign out now'
    end
  end
end
