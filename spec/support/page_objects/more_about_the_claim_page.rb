require_relative './base_page'
module ET1
  module Test
    class MoreAboutTheClaimPage < BasePage
      set_url "/en/apply/additional-information"


      # @param [ET1::Test::MoreAboutTheClaimUi] more_about_the_claim
      # @return [ET1::Test::MoreAboutTheClaimPage]
      def fill_in_all(more_about_the_claim:)
        provide_more_information_question.set(more_about_the_claim.provide_more_information)
        more_information_question.set(more_about_the_claim.more_information)
        self
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      # @!method provide_more_information_question
      #   A govuk radio button component for 'Do you want to provide additional information about your claim?' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :provide_more_information_question, :'more_about_the_claim.provide_more_information'

      # @!method more_information_question
      #   A govuk text area component for the 'Enter more detail about your claim' question
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      gds_text_area :more_information_question, :'more_about_the_claim.more_information'

      # @!method save_and_continue_button
      #   A govuk submit button component... for the save and continue button
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'more_about_the_claim.save_and_continue'
    end
  end
end
