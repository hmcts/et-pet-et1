require_relative './page_objects'
module ET1
  module Test
    module PageObjectHelpers

      # @return [::ET1::Test::ApplyPage]
      def apply_page
        ::ET1::Test::ApplyPage.new
      end

      # @return [ET1::Test::SavingYourClaimPage] The saving your claim page
      def saving_your_claim_page
        ::ET1::Test::SavingYourClaimPage.new
      end


      # @return [ET1::Test::ClaimantsDetailsPage]
      def claimants_details_page
        ::ET1::Test::ClaimantsDetailsPage.new
      end

      # @return [ET1::Test::GroupClaimsPage] The group claims page
      def group_claims_page
        ::ET1::Test::GroupClaimsPage.new
      end

      # @return [ET1::Test::GroupClaimsUploadPage] The group claims upload page
      def group_claims_upload_page
        ::ET1::Test::GroupClaimsUploadPage.new
      end

      # The representatives details page
      #
      # @return [ET1::Test::RepresentativesDetailsPage]
      def representatives_details_page
        ::ET1::Test::RepresentativesDetailsPage.new
      end


      # @return [ET1::Test::RespondentsDetailsPage]
      def respondents_details_page
        ::ET1::Test::RespondentsDetailsPage.new
      end

      def employment_details_page
        ::ET1::Test::EmploymentDetailsPage.new
      end

      def about_the_claim_page
        ::ET1::Test::AboutTheClaimPage.new
      end

      def claim_details_page
        ::ET1::Test::ClaimDetailsPage.new
      end

      def claim_outcome_page
        ::ET1::Test::ClaimOutcomePage.new
      end

      def more_about_the_claim_page
        ::ET1::Test::MoreAboutTheClaimPage.new
      end

      def check_your_claim_page
        ::ET1::Test::CheckYourClaimPage.new
      end

      def claim_submitted_page
        ::ET1::Test::ClaimSubmittedPage.new
      end
    end
  end
end

RSpec.configure do |c|
  c.include ::ET1::Test::PageObjectHelpers
end
