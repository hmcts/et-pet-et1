require_relative './base_page'
module ET1
  module Test
    class ClaimOutcomePage < BasePage
      set_url "/en/apply/claim-outcome"


      # @param [ET1::Test::ClaimOutcomeUi] claim_outcome The claim outcome data that the user submits
      # @return [ET1::Test::ClaimOutcomePage]
      def fill_in_all(claim_outcome:)
        what_do_you_want_question.set(claim_outcome.what_do_you_want)
        notes_question.set(claim_outcome.notes)
        self
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      # @!method what_do_you_want_question
      #   A govuk collection of checkboxes component for what do you want question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      gds_checkboxes :what_do_you_want_question, :'claim_outcome.what_do_you_want'

      # @!method notes_question
      #   A govuk text area component wrapping the input, label, hint etc.. for the 'What compensation or other outcome do you want?' question
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      gds_text_area :notes_question, :'claim_outcome.notes'

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'claim_outcome.save_and_continue'
    end
  end
end
