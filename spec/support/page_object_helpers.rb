module ET1
  module Test
    module PageObjectHelpers
      def apply_page
        ::ET1::Test::ApplyPage.new
      end

      def saving_your_claim_page
        ::ET1::Test::SavingYourClaimPage.new
      end

      # This one has phone numbers
      def claimants_details_page
        ::ET1::Test::ClaimantsDetailsPage.new
      end

      def group_claims_page
        ::ET1::Test::GroupClaimsPage.new
      end

      def group_claims_upload_page
        ::ET1::Test::GroupClaimsUploadPage.new
      end

      # This one has phone numbers
      def representatives_details_page
        ::ET1::Test::RepresentativesDetailsPage.new
      end

      # This one has phone numbers
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
