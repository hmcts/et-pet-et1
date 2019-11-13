require_relative './base_page'
module ET1
  module Test
    class GroupClaimsUploadPage < BasePage
      set_url "/en/apply/additional-claimants-upload"


      # Uploads the secondary claimants csv file
      # @param [String] csv_file The full path to the csv file to upload
      def upload_secondary_claimants_csv(csv_file)

      end

      # Switches to manual input by clicking on the link 'you can enter their details manually'
      def switch_to_manual_input

      end

      # Cancels the upload by clicking 'No' for the question 'Do you want to upload details of 6 claimants or more?'
      def cancel_upload

      end

      # Clicks the save and continue button
      def save_and_continue

      end
    end
  end
end
