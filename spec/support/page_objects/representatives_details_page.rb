require_relative './base_page'
module ET1
  module Test
    class RepresentativesDetailsPage < BasePage
      set_url "/en/apply/representative"

      # Fills in the representative's details by answering Yes to the question then filling in the details
      # @param [::ET1::Test::RepresentativeUi] representative The representative
      def fill_in_all(representative:)
        do_you_have_representative_question.set(:'representatives_details.do_you_have_representative.options.yes')
        fill_in_about_your_representative(representative)
        fill_in_representatives_contact_details(representative)
      end

      # Cancel the representative by clicking No in the primary question
      def no_representative
        do_you_have_representative_question.set(:'representatives_details.do_you_have_representative.options.no')
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
            [:about_your_representative_group, :representatives_contact_details_group].any? do |group|
              next unless send(group).respond_to?(question)
              send(group).send(question).assert_error_message(t(expected_message))
            end
          end

        end
      end


      private

      def fill_in_about_your_representative(representative)
        about_your_representative_group.tap do |s|
          s.type_question.set(representative.type)
          s.name_of_organisation_question.set(representative.name_of_organisation)
          s.name_question.set(representative.name)
        end
      end

      def fill_in_representatives_contact_details(representative)
        representatives_contact_details_group.tap do |s|
          s.building_question.set(representative.address_building)
          s.street_question.set(representative.address_street)
          s.town_question.set(representative.address_town)
          s.county_question.set(representative.address_county)
          s.post_code_question.set(representative.address_post_code)
          s.phone_or_mobile_number_question.set(representative.phone_or_mobile_number)
          s.alternative_phone_or_mobile_number_question.set(representative.alternative_phone_or_mobile_number)
          s.email_address_question.set(representative.email_address)
          s.dx_number_question.set(representative.dx_number)
          s.best_correspondence_method_question.set(representative.best_correspondence_method)
        end
      end

      # @!method do_you_have_representative_question
      #   A govuk radio button component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :do_you_have_representative_question, :'representatives_details.do_you_have_representative'
      # @!method about_your_representative_group
      #   A govuk fieldset component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_fieldset :about_your_representative_group, :'representatives_details.about_your_representative_group' do
        include EtTestHelpers::Section

        # @!method type_question
        #   A govukselect component wrapping the select, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
        gds_select :type_question, :'representatives_details.type.label'
        # @!method name_of_organisation_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :name_of_organisation_question, :'representatives_details.name_of_organisation'
        # @!method name_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :name_question, :'representatives_details.name'
      end

      # @!method representatives_contact_details_group
      #   A govuk fieldset component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKFieldset] The site prism section
      gds_fieldset :representatives_contact_details_group, :'representatives_details.representatives_contact_details_group' do
        include EtTestHelpers::Section
        # @!method building_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :building_question, :'representatives_details.building'
        # @!method street_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :street_question, :'representatives_details.street'
        # @!method town_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :town_question, :'representatives_details.town'
        # @!method county_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :county_question, :'representatives_details.county'
        # @!method post_code_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :post_code_question, :'representatives_details.post_code'
        # @!method phone_or_mobile_number_question
        #   A govuk phone field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
        gds_phone_input :phone_or_mobile_number_question, :'representatives_details.phone_or_mobile_number'
        # @!method alternative_phone_or_mobile_number_question
        #   A govuk phone field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
        gds_phone_input :alternative_phone_or_mobile_number_question, :'representatives_details.alternative_phone_or_mobile_number'
        # @!method email_address_question
        #   A govuk email field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKEmailField] The site prism section
        gds_email_input :email_address_question, :'representatives_details.email_address'
        # @!method dx_number_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_text_input :dx_number_question, :'representatives_details.dx_number'
        # @!method best_correspondence_method_question
        #   A govuk collection radio buttons component
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButton] The site prism section
        gds_radios :best_correspondence_method_question, :'representatives_details.best_correspondence_method'
      end

      # @!method save_and_continue_element
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'representatives_details.save_and_continue'
    end
  end
end
