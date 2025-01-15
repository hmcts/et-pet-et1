require_relative './base_page'
module ET1
  module Test
    class CaseHeardByPage < BasePage
      set_url "/en/apply/case-heard-by"


      def fill_in_all(claimant:)
        fill_in_case_heard_by(claimant: claimant)
        self
      end
      # Fills in the claimant's personal info
      # @param [Claimant] claimant The claimant
      def fill_in_case_heard_by(claimant:)
        case_heard_by_preference_question.set(claimant.case_heard_by_preference)
        case_heard_by_preference_reason_question.set(claimant.case_heard_by_preference_reason) if claimant.case_heard_by_preference.to_s.split('.').last.in?(%w[judge panel])
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      def save_and_complete_later
        save_and_complete_later_element.click
        SaveAndCompleteLaterPage.new
      end


      # @param [Hash] error_messages A list of error messages keyed by the question name (ignoring groups)
      def assert_error_messages(error_messages)
        aggregate_failures 'validating error messages' do
          error_messages.each_pair do |question_prefix, expected_message|
            question = :"#{question_prefix}_question"
            next unless respond_to?(question)
            send(question).assert_error_message(t(expected_message))
          end
        end
      end

      private

      # @!method case_heard_by_preference_question
      #   A govuk radio button component for the case heard by preference question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :case_heard_by_preference_question, :'case_heard_by.case_heard_by_preference'

      # @!method case_heard_by_preference_reason_question
      #   A govuk text area component for the optional case heard by preference reason question
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      gds_text_area :case_heard_by_preference_reason_question, :'case_heard_by.case_heard_by_preference_reason'

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'claimants_details.save_and_continue'
      element :save_and_complete_later_element, :link_or_button_translated, 'claimants_details.save_and_complete_later'
    end
  end
end
