require_relative './base_page'
module ET1
  module Test
    class AboutTheClaimPage < BasePage
      set_url "/en/apply/claim-type"


      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      def assert_questions
        expect(page).not_to have_text("Unfair dismissal (including constructive dismissal) (optional)", wait: false)
        expect(page).to have_text("Unfair dismissal (including constructive dismissal)")

        expect(page).not_to have_text("Other type of claim (optional)", wait: false)
        expect(page).to have_text("Other type of claim")

        expect(page).not_to have_text("Are you reporting suspected wrongdoing at work? (optional)", wait: false)
        expect(page).to have_text("Are you reporting suspected wrongdoing at work?")
        self
      end

      section :whistle_blowing_fieldset, :govuk_fieldset, :'claim_type.is_whistleblowing.heading' do
        include EtTestHelpers::Section

        # @!method whistle_blowing_question
        #   A govuk radio button component for whistle blowing question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :whistle_blowing_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claim_type.is_whistleblowing.label'

        # @!method whistle_blowing_body_question
        #   A govuk radio button component for whistle blowing send to body question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :whistle_blowing_body_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claim_type.send_claim_to_whistleblowing_entity.label'
      end

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'claim_type.save_and_continue'
    end
  end
end
