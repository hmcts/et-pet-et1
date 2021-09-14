module ET1
  module Test
    module Refunds
      class FeesPage < BasePage
        gds_error_summary :form_error_message, "Provide information in the highlighted fields."
        element :help, '[data-behavior=help]'
        # @!method original_claim_fees
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        gds_fieldset :original_claim_fees, "Complete the relevant fields for fees you have paid" do
          include EtTestHelpers::Section
          # @!method et_issue
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_fieldset :et_issue, "ET Issue" do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            gds_text_input :fee_question, 'Fee (in pounds)'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            gds_date_input :payment_date_question, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            gds_checkbox :payment_date_unknown_question, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            gds_select :payment_method_question, 'Payment method'
          end

          # @!method et_hearing
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_fieldset :et_hearing, "ET Hearing" do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            gds_text_input :fee_question, 'Fee (in pounds)'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            gds_date_input :payment_date_question, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            gds_checkbox :payment_date_unknown_question, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            gds_select :payment_method_question, 'Payment method'
          end

          # @!method et_reconsideration
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_fieldset :et_reconsideration, "ET Reconsideration" do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            gds_text_input :fee_question, 'Fee (in pounds)'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            gds_date_input :payment_date_question, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            gds_checkbox :payment_date_unknown_question, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            gds_select :payment_method_question, 'Payment method'
          end

          # @!method eat_issue
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_fieldset :eat_issue, "EAT Issue" do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            gds_text_input :fee_question, 'Fee (in pounds)'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            gds_date_input :payment_date_question, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            gds_checkbox :payment_date_unknown_question, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            gds_select :payment_method_question, 'Payment method'
          end

          # @!method eat_hearing
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          gds_fieldset :eat_hearing, "EAT Hearing" do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            gds_text_input :fee_question, 'Fee (in pounds)'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            gds_date_input :payment_date_question, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            gds_checkbox :payment_date_unknown_question, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            gds_select :payment_method_question, 'Payment method'
          end

          section :total, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Total fees paid")]] }) do
            element :fee, '[data-behavior=\'total_fees\']'
          end
        end

        def has_valid_help_section?
          messages = [
            "Fees were charged in the Employment Tribunal and Employment Appeals Tribunal between 29 July 2013 and 26 July 2017",
            "A type A claim had an issue fee of £160 and a hearing fee of £230.",
            "A type B claim had an issue fee of £250 and a hearing fee of £950.",
            "An Employment Appeal Tribunal fee had a lodgement fee of £400 and a hearing fee of £1200."
          ]
          help.assert_text(messages.join("\n"))
        end

        gds_submit_button :save_and_continue, 'Continue'
      end
    end

  end
end
