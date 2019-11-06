require_relative './base_page'
module ET1
  module Test
    class SavingYourClaimPage < BasePage
      set_url "/en/apply/application-number"

      # @return [String] The claim number assigned to you
      def claim_number

      end

      # Registers the user for a save and return
      def register(email_address, password)

      end
    end
  end
end
