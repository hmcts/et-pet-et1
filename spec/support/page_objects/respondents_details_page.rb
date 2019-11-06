require_relative './base_page'
module ET1
  module Test
    class RespondentsDetailsPage < BasePage
      set_url "/en/apply/respondent"

      # Fills in the respondent's details
      # @param [Respondent] respondent The respondent
      def fill_in_respondent(respondent)

      end

      # Answers No to 'Did you work at the same address .....' and fills in the address and phone number
      # @param [Address] address
      # @param [String] phone_number
      def different_work_address(address, phone_number)

      end

      # Cancels the different work address by answering "Yes" to 'Did you work at the same address ....'
      def cancel_different_work_address

      end


      # Fills in the acas number
      # @param [String] acas_number
      def fill_in_acas_number(acas_number)

      end

      # Fills in 'I dont have an acas number' and the reason why
      # @param [String] reason_code The code to decide which option to select for the reason
      def fill_in_no_acas_number(reason_code)

      end

      # Cancels the filling in of 'I dont have an acas number' by unchecking 'I dont have an acas number'
      def cancel_no_acas_number

      end

      # Clicks the save and continue button
      def save_and_continue

      end
    end
  end
end
