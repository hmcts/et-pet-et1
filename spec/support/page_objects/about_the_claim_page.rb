require_relative './base_page'
module ET1
  module Test
    class AboutTheClaimPage < BasePage
      set_url "/en/apply/claim-type"


      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      # @param [ET1::Test::ClaimTypeUi] claim_type The claim type data from the user
      def fill_in_all(claim_type:)
        unfair_dismissal_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.unfair_dismissal} })
        discrimination_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.discrimination} })
        pay_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.pay} })
        other_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.other} })
        claim_type_other_details_question.set(claim_type.claim_type_other_details)
        whistle_blowing_fieldset.tap do |section|
          section.whistle_blowing_question.set(claim_type.is_whistleblowing)
          section.whistle_blowing_body_question.set(claim_type.whistleblowing_forward_claim)
        end
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

      # @!method unfair_dismissal_question
      #   A govuk collection of checkboxes component for unfair dismissal question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      gds_checkboxes :unfair_dismissal_question, :'claim_type.unfair_dismissal'

      # @!method discrimination_question
      #   A govuk collection of checkboxes component for discrimination question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      gds_checkboxes :discrimination_question, :'claim_type.discrimination'

      # @!method pay_question
      #   A govuk collection of checkboxes component for discrimination question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      gds_checkboxes :pay_question, :'claim_type.pay'

      # @!method other_question
      #   A govuk collection of checkboxes component for other type of claim question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      gds_checkboxes :other_question, :'claim_type.other'

      # @!method claim_type_other_details_question
      #   A govuk text area component wrapping the input, label, hint etc.. for the 'State the other type of claim that you are making'
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      gds_text_area :claim_type_other_details_question, :'claim_type.claim_type_other_details'

      gds_fieldset :whistle_blowing_fieldset, :'claim_type.is_whistleblowing.heading' do
        include EtTestHelpers::Section

        # @!method whistle_blowing_question
        #   A govuk radio button component for whistle blowing question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :whistle_blowing_question, :'claim_type.is_whistleblowing'

        # @!method whistle_blowing_body_question
        #   A govuk radio button component for whistle blowing send to body question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :whistle_blowing_body_question, :'claim_type.send_claim_to_whistleblowing_entity'
      end

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'claim_type.save_and_continue'
    end
  end
end
