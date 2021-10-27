require_relative './base_page'
module ET1
  module Test
    class ResetMemorableWordEmailInstructionsPage < BasePage

      def using(email_address:, claim_number: nil)
        fieldset.email_address_question.set(email_address)
        fieldset.claim_number_question.set(claim_number) unless claim_number.nil?
        fieldset.submit_button.submit
        ReturnToYourClaimPage.new
      end

      private

      # @!method fieldset
      #   A govuk fieldset component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKFieldset] The site prism section
      gds_fieldset :fieldset, :'reset_memorable_word_instructions.enter_your_details_fieldset' do
        include EtTestHelpers::Section
        # @!method email_address_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :email_address_question, :'reset_memorable_word_instructions.email_address'

        # @!method claim_number_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :claim_number_question, :'reset_memorable_word_instructions.claim_number'

        # @!method submit_button
        #   A govuk submit button component...
        #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
        gds_submit_button :submit_button, :'reset_memorable_word_instructions.reset_memorable_word'
      end
    end
  end
end
