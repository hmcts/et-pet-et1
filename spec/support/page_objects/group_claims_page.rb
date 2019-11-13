require_relative './base_page'
module ET1
  module Test
    class GroupClaimsPage < BasePage
      set_url "/en/apply/additional-claimants"

      # Adds a list of secondary claimants using the user interface - it clicks "Yes" to the 'People making a claim with you'
      # question, then fills in the sections below it.
      # This is limited to  a max of 5 secondary claimants.
      # Any more than that, the user will need to call provide_spreadsheet and then use
      # the GroupClaimsUploadPage page object to upload the spreadsheet
      # @param [Array<Claimant>] claimants An array of claimants to add
      def add_secondary_claimants(claimants)

      end

      # Clicks on the link to provide the spreadsheet instead of using the user interface
      def provide_spreadsheet

      end

      # Clicks on no to the primary question of 'People making a claim with you'
      def no_secondary_claimants
        people_making_claim_with_you_question.set(:'group_claims.people_making_claim_with_you.options.no')
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_element.click
      end

      private

      section :people_making_claim_with_you_question,
              ::ET1::Test::RadioButtonsQuestionSection,
              :question_group_labelled_translated, 'group_claims.people_making_claim_with_you.label'

      element :save_and_continue_element, :button_translated, 'group_claims.save_and_continue'
    end
  end
end
