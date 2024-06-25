require_relative './base_page'
module ET1
  module Test
    class RespondentsDetailsPage < BasePage
      set_url "/en/apply/respondent"

      # Fills in the respondent's details
      # @param [ET1::Test::RespondentUi] respondent The respondent
      def fill_in_all(respondent:)
        fill_in_about_the_respondent_group(respondent)
        fill_in_your_work_address_group(respondent)
        fill_in_acas_number(respondent)
        fill_in_dont_have_acas_number(respondent)
        self
      end

      # Fills in the acas number
      # @param [ET1::Test::RespondentUi] respondent
      def fill_in_acas_number(respondent)
        have_acas_number_question.set(respondent.has_acas_number)
        if respondent.has_acas_number.to_s.split('.').last == 'yes'
          acas_number_question.set(respondent.acas_number)
        end
      end

      # Fills in the section where you dont have an acas number
      # @param [ET1::Test::RespondentUi] respondent
      def fill_in_dont_have_acas_number(respondent)
        return self if respondent.has_acas_number.to_s.split('.').last == 'yes'

        have_acas_number_question.set(respondent.has_acas_number)
        dont_have_acas_number_reason.set(respondent.dont_have_acas_number_reason)
        self
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
        end
      end

      def assert_correct_hints(respondent)
        expect(page).to have_text 'Please note: Incorrectly claiming an exemption may lead to your claim being rejected. If in doubt, please contact ACAS.'
        if respondent.dont_have_acas_number_reason.to_s.split('.').last == 'interim_relief'
          expect(self).to have_text 'Please note: This is a rare type of claim. The fact that you are making a claim of unfair dismissal does not mean you are necessarily making a claim for interim relief.'
        else
          expect(self).to have_no_text 'Please note: This is a rare type of claim. The fact that you are making a claim of unfair dismissal does not mean you are necessarily making a claim for interim relief.'
        end
        self
      end
      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
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

        # @!method about_the_respondent_group
          #   A govuk fieldset component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKFieldset] The site prism section
      section :about_the_respondent_group, :govuk_fieldset, :'respondents_details.about_the_respondent_group' do
        include EtTestHelpers::Section
        # @!method name_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :name_question, :'respondents_details.name'
        # @!method building_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :building_question, :'respondents_details.building'
        # @!method street_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :street_question, :'respondents_details.street'
        # @!method town_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :town_question, :'respondents_details.town'
        # @!method county_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :county_question, :'respondents_details.county'
        # @!method post_code_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :post_code_question, :'respondents_details.post_code'
      end
      section :your_work_address_group, :govuk_fieldset, :'respondents_details.your_work_address_group' do
        include EtTestHelpers::Section
        # @!method worked_at_same_address_question
        #   A govuk radio button component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :worked_at_same_address_question, :'respondents_details.worked_at_same_address'

        # @!method work_building_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :work_building_question, :'respondents_details.work_building'
        # @!method work_street_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :work_street_question, :'respondents_details.work_street'
        # @!method work_town_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :work_town_question, :'respondents_details.work_town'
        # @!method work_county_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :work_county_question, :'respondents_details.work_county'
        # @!method work_post_code_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :work_post_code_question, :'respondents_details.work_post_code'
      end

      # @!method have_acas_number_question
      #   A govuk radio button component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :have_acas_number_question, :'respondents_details.have_acas_number'
      # @!method acas_number_question
      #   A govuk text field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_input :acas_number_question, :'respondents_details.acas_number'
      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'respondents_details.save_and_continue'
      # @!method dont_have_acas_number_reason
      #   A govuk radio button component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :dont_have_acas_number_reason, :'respondents_details.dont_have_acas_number_reason'
    end
  end
end
