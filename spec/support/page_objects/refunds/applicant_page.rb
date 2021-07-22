require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class ApplicantPage < BasePage
        gds_error_summary :form_error_message, "Provide information in the highlighted fields."
        # @!method has_name_changed_question
        #   A govuk radio button component for has_name_changed question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :has_name_changed_question, 'Has your name changed since you made your employment tribunal claim ?'

        # @!method about_the_claimant
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_fieldset :about_the_claimant, "About you" do
          include EtTestHelpers::Section
          # @!method title_question
          #   A govukselect component wrapping the select, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
          gds_select :title_question, 'Title'
          # @!method first_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :first_name_question, 'First name'
          # @!method last_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :last_name_question, 'Last name'
          # @!method date_of_birth_question
          #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
          #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
          gds_date_input :date_of_birth_question, 'Date of birth'

        end

        # @!method claimants_contact_details
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_fieldset :claimants_contact_details, "Your contact details" do
          include EtTestHelpers::Section
          # @!method building_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :building_question, 'Building number or name'
          # @!method street_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :street_question, 'Street'
          # @!method locality_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :locality_question, 'Town/city'
          # @!method county_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :county_question, 'County'
          # @!method post_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :post_code_question, 'UK Postcode'
          # @!method telephone_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
          gds_phone_input :telephone_number_question, 'Phone or mobile number'
          # @!method email_address_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKEmailField] The site prism section
          gds_email_input :email_address_question, 'Email address'
        end
        gds_submit_button :save_and_continue, 'Continue'
      end
    end

  end
end
