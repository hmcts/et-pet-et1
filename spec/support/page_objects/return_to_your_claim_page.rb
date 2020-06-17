require_relative './base_page'
module ET1
  module Test
    class ReturnToYourClaimPage < BasePage

      def assert_missing_claim_number
        invalid_word_or_number_flash_element
      end

      def return_to_your_claim(claim_number:, memorable_word:)
        memorable_word_element.set(memorable_word) unless memorable_word.nil?
        claim_number_element.set(claim_number) unless claim_number.nil?
        submit_button.click
      end

      def reset_memorable_word
        reset_memorable_word_element.click
        ResetMemorableWordEmailInstructionsPage.new
      end

      def assert_memorable_word_email_sent
        memorable_word_email_sent_flash_element
      end

      private

      element :memorable_word_element, :fillable_field, "Memorable word"
      element :claim_number_element, :fillable_field, "Claim number"
      element :reset_memorable_word_element, :link, 'Click here to reset'
      element :submit_button, :button, 'Find my claim'
      element :memorable_word_email_sent_flash_element, '#flash-summary *', text: 'You will receive an email with instructions on how to reset your memorable word in a few minutes'
      element :invalid_word_or_number_flash_element, '#flash-summary *', text: 'Invalid memorable word or claim number.'
    end
  end
end
