require_relative './base_page'
module ET1
  module Test
    class ClaimantsDetailsPage < BasePage
      set_url "/en/apply/claimant"


      # Fills in the claimant's personal info
      # @param [Claimant] claimant The claimant
      def fill_in_personal_info(claimant)

      end

      # Fills in the special needs section
      # @param [Boolean] has_special_needs A boolean to indicate if the claimant has special needs or not
      # @param [String, NilClass] special_needs A string containing the special needs to fill in (nil if not needed)
      def fill_in_special_needs(has_special_needs:, special_needs:)

      end

      # Fills in the contact details section
      # @param [Claimant] claimant The claimant
      def fill_in_contact_details(claimant)

      end

      # Clicks the save and continue button
      def save_and_continue

      end

    end
  end
end
