module ET1
  module Test
    module Refunds
      class OriginalCaseDetailsPage < BasePage
        section :original_case_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your case details")]] }) do
          include EtTestHelpers::Section
          # @!method et_country_of_claim_question
          #   A govukselect component wrapping the select, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
          gds_select :et_country_of_claim_question, 'Where was your claim issued?'
          # @!method et_case_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :et_case_number_question, 'Employment tribunal case number (optional)'
          # @!method eat_case_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :eat_case_number_question, 'Employment appeal tribunal case number (optional)'
          # @!method et_tribunal_office_question
          #   A govukselect component wrapping the select, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
          gds_select :et_tribunal_office_question, 'Employment tribunal office (optional)'
          # @!method additional_information_question
          #   A govuk text area component wrapping the input, label, hint etc.. for a text area
          #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
          gds_text_area :additional_information_question, 'Additional information (optional)'
        end
        section :original_claimant_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your address at the time of your claim")]] }) do
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
          gds_text_input :locality_question, 'Town/city (optional)'
          # @!method county_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :county_question, 'County (optional)'
          # @!method post_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :post_code_question, 'UK Postcode'
          # @!method telephone_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :telephone_number_question, 'Phone or mobile number'
          # @!method email_address_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :email_address_question, 'Email address'
        end
        section :original_respondent_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Who was your claim against (Respondent)")]] }) do
          include EtTestHelpers::Section
          # @!method name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :name_question, 'Respondent name'
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
          gds_text_input :locality_question, 'Town/city (optional)'
          # @!method county_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :county_question, 'County (optional)'
          # @!method post_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :post_code_question, 'UK Postcode (optional)'
        end
        # @!method claim_had_representative_question
        #   A govuk radio button component for claim_had_representative question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :claim_had_representative_question, 'Did you have a representative at the time of your original claim ?'
        section :original_representative_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Representative")]] }) do
          include EtTestHelpers::Section
          # @!method name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :name_question, 'Representative name'
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
          gds_text_input :locality_question, 'Town/city (optional)'
          # @!method county_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :county_question, 'County (optional)'
          # @!method post_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :post_code_question, 'UK Postcode'
        end
        # @!method address_changed_question
        #   A govuk radio button component for address_changed question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :address_changed_question, "Has your address changed since you made your employment tribunal claim ?"
        gds_submit_button :save_and_continue, 'Continue'
      end
    end

  end
end
