require_relative './base_page'
module ET1
  module Test
    class RespondentsDetailsPage < BasePage
      set_url "/en/apply/respondent"

      # Fills in the respondent's details
      # @param [ET1::Test::RespondentUi] respondent The respondent
      def fill_in_respondent(respondent)
        fill_in_about_the_respondent_group(respondent)
        fill_in_your_work_address_group(respondent)
        fill_in_acas_number(respondent)
        fill_in_dont_have_acas_number(respondent)
      end

      # Fills in the acas number
      # @param [ET1::Test::RespondentUi] respondent
      def fill_in_acas_number(respondent)
        return if respondent.dont_have_acas_number

        dont_have_acas_number_question.set(false)
        acas_number_question.set(respondent.acas_number)
      end

      # Fills in the section where you dont have an acas number
      # @param [ET1::Test::RespondentUi] respondent
      def fill_in_dont_have_acas_number(respondent)
        return unless respondent.dont_have_acas_number

        dont_have_acas_number_question.set(true)
        dont_have_acas_number_reason.set(respondent.dont_have_acas_number_reason)
      end

      # @param [ET1::Test::RespondentUi] respondent
      def fill_in_about_the_respondent_group(respondent)
        about_the_respondent_group.tap do |s|
          s.name_question.set(respondent.name)
          s.building_question.set(respondent.address_building)
          s.street_question.set(respondent.address_street)
          s.town_question.set(respondent.address_town)
          s.county_question.set(respondent.address_county)
          s.post_code_question.set(respondent.address_post_code)
          s.phone_number_question.set(respondent.phone_number)
        end
      end

      # @param [ET1::Test::RespondentUi] respondent
      def fill_in_your_work_address_group(respondent)
        your_work_address_group.tap do |s|
          s.worked_at_same_address_question.set(respondent.worked_at_same_address)
          next if respondent.worked_at_same_address.to_s.split('.').last == 'yes'

          s.work_building_question.set(respondent.work_address_building)
          s.work_street_question.set(respondent.work_address_street)
          s.work_town_question.set(respondent.work_address_town)
          s.work_county_question.set(respondent.work_address_county)
          s.work_post_code_question.set(respondent.work_address_post_code)
          s.work_phone_number_question.set(respondent.work_address_phone_number)
        end
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_element.click
      end

      # @param [Hash] error_messages A list of error messages keyed by the question name (ignoring groups)
      def assert_error_messages(error_messages)
        aggregate_failures 'validating error messages' do
          error_messages.each_pair do |question_prefix, expected_message|
            question = :"#{question_prefix}_question"
            [:about_the_respondent_group, :your_work_address_group, :itself].any? do |group|
              next unless send(group).respond_to?(question)
              send(group).send(question).assert_error_message(t(expected_message))
            end
          end

        end
      end

      private

      section :about_the_respondent_group, :fieldset_translated, 'respondents_details.about_the_respondent_group' do
        section :name_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.name.label'
        section :building_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.building.label'
        section :street_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.street.label'
        section :town_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.town.label'
        section :county_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.county.label'
        section :post_code_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.post_code.label'
        section :phone_number_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.phone_number.label'
      end
      section :your_work_address_group, :fieldset_translated, 'respondents_details.your_work_address_group' do
        section :worked_at_same_address_question, ::ET1::Test::RadioButtonsQuestionSection, :question_group_labelled_translated, 'respondents_details.worked_at_same_address.label'
        section :work_building_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.work_building.label'
        section :work_street_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.work_street.label'
        section :work_town_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.work_town.label'
        section :work_county_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.work_county.label'
        section :work_post_code_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.work_post_code.label'
        section :work_address_phone_number_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'respondents_details.work_address_phone_number.label'
      end

      section :dont_have_acas_number_question, ::ET1::Test::CheckboxQuestionSection, :checkbox_question_labelled_translated, 'respondents_details.dont_have_acas_number.label'
      section :acas_number_question, ::ET1::Test::TextQuestionSection, :question_group_labelled_translated, 'respondents_details.acas_number.label'
      element :save_and_continue_element, :button_translated, 'respondents_details.save_and_continue'
    end
  end
end
