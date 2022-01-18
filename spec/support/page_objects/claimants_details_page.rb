require_relative './base_page'
module ET1
  module Test
    class ClaimantsDetailsPage < BasePage
      set_url "/en/apply/claimant"


      def fill_in_all(claimant:)
        fill_in_personal_info(claimant: claimant)
        fill_in_special_needs(claimant: claimant)
        fill_in_contact_details(claimant: claimant)
        self
      end
      # Fills in the claimant's personal info
      # @param [Claimant] claimant The claimant
      def fill_in_personal_info(claimant:)
        about_the_claimant_group.tap do |s|
          s.title_question.set(claimant.title)
          s.first_name_question.set(claimant.first_name)
          s.last_name_question.set(claimant.last_name)
          s.date_of_birth_question.set(claimant.date_of_birth)
          s.gender_question.set(claimant.gender)
        end
      end

      # Fills in the special needs section
      # @param [Boolean] has_special_needs A boolean to indicate if the claimant has special needs or not
      # @param [String, NilClass] special_needs A string containing the special needs to fill in (nil if not needed)
      def fill_in_special_needs(claimant:)
        about_the_claimant_group.tap do |s|
          s.has_special_needs_question.set(claimant.has_special_needs)
          s.special_needs_question.set(claimant.special_needs) if claimant.has_special_needs.to_s.split('.').last == 'yes'
        end
      end

      # Fills in the contact details section
      # @param [Claimant] claimant The claimant
      def fill_in_contact_details(claimant:)
        claimants_contact_details_group.tap do |s|
          s.building_question.set(claimant.address_building)
          s.street_question.set(claimant.address_street)
          s.town_question.set(claimant.address_town)
          s.county_question.set(claimant.address_county)
          s.post_code_question.set(claimant.address_post_code)
          s.country_question.set(claimant.address_country)
          s.phone_or_mobile_number_question.set(claimant.phone_or_mobile_number)
          s.alternative_phone_or_mobile_number_question.set(claimant.alternative_phone_or_mobile_number)
          s.best_correspondence_method_question.set(claimant.best_correspondence_method)
          s.email_address_question.set(claimant.email_address) if claimant.best_correspondence_method.to_s.split('.').last == 'email'
          s.allow_video_attendance_question.set(claimant.allow_video_attendance)
        end
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
            [:about_the_claimant_group, :claimants_contact_details_group].any? do |group|
              next unless send(group).respond_to?(question)
              send(group).send(question).assert_error_message(t(expected_message))
            end
          end

        end
      end

      private

      section :about_the_claimant_group, :fieldset_translated, 'claimants_details.about_the_claimant_group' do
        include EtTestHelpers::Section
        # @!method title_question
        #   A govukselect component wrapping the select, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
        gds_select :title_question, :'claimants_details.title'

        # @!method first_name_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :first_name_question, :'claimants_details.first_name'

        # @!method govuk_text_field
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :last_name_question, :'claimants_details.last_name'

        # @!method date_of_birth_question
        #   A govuk date field component wrapping the input, label, hint etc.. for the date of birth question
        #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
        gds_date_input :date_of_birth_question, :'claimants_details.date_of_birth'

        # @!method gender_question
        #   A govuk radio button component for the gender question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :gender_question, :'claimants_details.gender'

        # @!method has_special_needs_question
        #   A govuk radio button component for the has special needs question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :has_special_needs_question, :'claimants_details.has_special_needs'

        # @!method special_needs_question
        #   A govuk text area component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
        gds_text_area :special_needs_question, :'claimants_details.special_needs'
      end

      section :claimants_contact_details_group, :fieldset_translated, 'claimants_details.claimants_contact_details_group' do
        include EtTestHelpers::Section
        # @!method building_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :building_question, :'claimants_details.building'

        # @!method street_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :street_question, :'claimants_details.street'

        # @!method town_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :town_question, :'claimants_details.town'

        # @!method county_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :county_question, :'claimants_details.county'

        # @!method post_code_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :post_code_question, :'claimants_details.post_code'

        # @!method country_question
        #   A govukselect component wrapping the select, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
        gds_radios :country_question, :'claimants_details.country'

        # @!method phone_or_mobile_number_question
        #   A govuk phone field component representing the phone or mobile question
        #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
        gds_phone_input :phone_or_mobile_number_question, :'claimants_details.phone_or_mobile_number'

        # @!method alternative_phone_or_mobile_number_question
        #   A govuk phone field component representing the alternative phone or mobile question
        #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
        gds_phone_input :alternative_phone_or_mobile_number_question, :'claimants_details.alternative_phone_or_mobile_number'

        # @!method email_address_question
        #   A govuk email field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKEmailField] The site prism section
        gds_email_input :email_address_question, :'claimants_details.email_address'

        # @!method best_correspondence_method_question
        #   A govuk radio button component for the gender question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :best_correspondence_method_question, :'claimants_details.best_correspondence_method'
        # @!method allow_video_attendance_question
        #   A govuk radio button component for the video question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :allow_video_attendance_question, :'claimants_details.allow_video_attendance'
      end

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'claimants_details.save_and_continue'
      element :save_and_complete_later_element, :link_or_button_translated, 'claimants_details.save_and_complete_later'

    end
  end
end
