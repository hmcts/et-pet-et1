require_relative './base_page'
module ET1
  module Test
    class RepresentativesDetailsPage < BasePage
      set_url "/en/apply/representative"

      # Fills in the representative's details by answering Yes to the question then filling in the details
      # @param [Representative] representative The representative
      def fill_in_representative(representative)

      end

      # Cancel the representative by clicking No in the primary question
      def cancel_representative

      end

      # Clicks the save and continue button
      def save_and_continue

      end
    end
  end
end
