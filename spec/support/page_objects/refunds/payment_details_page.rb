require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class PaymentDetailsPage < BasePage
        set_url "/en/apply/refund/bank-details"
        # @!method account_type_question
        #   A govuk radio button component for account_type question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :account_type_question, 'Account type'
        # @!method bank_details
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_fieldset :bank_details, "Your Bank Details" do
          include EtTestHelpers::Section
          # @!method account_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :account_name_question, 'Bank account holder name'
          # @!method bank_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :bank_name_question, 'Bank name'
          # @!method account_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :account_number_question, 'Bank account number'
          # @!method sort_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :sort_code_question, 'Bank sort code'
        end
        gds_fieldset :building_society_details, "Your Building Society Details" do
          include EtTestHelpers::Section
          # @!method account_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :account_name_question, 'Building Society account holder name'
          # @!method building_society_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :building_society_name_question, 'Building Society name'
          # @!method account_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :account_number_question, 'Building Society account number'
          # @!method sort_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_text_input :sort_code_question, 'Building Society sort code'
        end
        gds_submit_button :save_and_continue, 'Continue'
      end
    end

  end
end
