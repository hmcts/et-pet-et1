require_relative './base_page'
module ET1
  module Test
    class GroupClaimsPage < BasePage
      set_url "/en/apply/additional-claimants"

      # Adds a list of secondary claimants using the user interface - it clicks "Yes" to the 'People making a claim with you'
      # question, then fills in the sections below it.
      # This is limited to  a max of 5 secondary claimants.
      # Any more than that, the user will need to call provide_spreadsheet and then use
      # the GroupClaimsUploadPage page object to upload the spreadsheet
      # @param [Array<Claimant>] claimants An array of claimants to add
      def add_secondary_claimants(claimants)

      end

      # Clicks on the link to provide the spreadsheet instead of using the user interface
      def provide_spreadsheet

      end

      # Clicks the save and continue button
      def save_and_continue

      end
    end
  end
end
