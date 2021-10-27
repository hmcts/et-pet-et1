require_relative './base_page'
module ET1
  module Test
    class ClaimDetailsPage < BasePage
      set_url "/en/apply/claim-details"

      # Fills in the whole form
      # @param [ET1::Test::ClaimDetailsUi] claim_details
      def fill_in_all(claim_details:)
        claim_details_question.set(claim_details.text)
        ensure_file_question_is_visible unless claim_details.rtf_file_path.nil?
        claim_details_file_question.set(claim_details.rtf_file_path) unless claim_details.rtf_file_path.nil?
        other_known_claimants_question.set(claim_details.other_known_claimants)
        other_known_claimant_names_question.set(claim_details.other_known_claimant_names) unless claim_details.other_known_claimants.to_s.split('.').last == 'no'
        self
      end

      def remove_rtf_file
        remove_rtf_file_question.set(true)
        self
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      # @!method claim_details_question
      #   A govuk text field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_area :claim_details_question, :'claim_details.claim_details'

      # @!method claim_details_file_question
      #   A govuk file field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKFileField] The site prism section
      gds_file_upload :claim_details_file_question, :'claim_details.rtf_file'

     # @!method remove_rtf_file_question
      #   A govuk file field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKFileField] The site prism section
      gds_checkbox :remove_rtf_file_question, :'claim_details.remove_rtf_file.label'

      # @!method other_known_claimants_question
      #   A govuk radio button component for the other known claimants question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :other_known_claimants_question, :'claim_details.other_known_claimants'

      # @!method other_known_claimant_names_question
      #   A govuk text area component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      gds_text_area :other_known_claimant_names_question, :'claim_details.other_known_claimant_names'

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'claim_details.save_and_continue'

      # @!method upload_separate_document_section
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKDetails] The site prism section
      gds_details :upload_separate_document_section, :'claim_details.upload_separate_document_section.label'

      def ensure_file_question_is_visible
        upload_separate_document_section.open
        self
      end
    end
  end
end
