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

      def new_claim_page
        @new_claim_page ||= NewClaimPage.new
      end

      def step_one_page
        @step_one_page ||= StepOnePage.new
      end

      def step_two_page
        @step_two_page ||= StepTwoPage.new
      end

      def step_three_page
        @step_three_page ||= StepThreePage.new
      end

      def step_four_page
        @step_four_page ||= StepFourPage.new
      end

      def step_five_page
        @step_five_page ||= StepFivePage.new
      end

      def step_six_page
        @step_six_page ||= StepSixPage.new
      end

      def step_seven_page
        @step_seven_page ||= StepSevenPage.new
      end

      def step_eight_page
        @step_eight_page ||= StepEightPage.new
      end

      def step_nine_page
        @step_nine_page ||= StepNinePage.new
      end

      def step_ten_page
        @step_ten_page ||= StepTenPage.new
      end

      def step_eleven_page
        @step_eleven_page ||= StepElevenPage.new
      end

      def submission_page
        @submission_page ||= SubmissionPage.new
      end

      def claim_submitted_page
        @claim_submitted_page ||= ClaimSubmittedPage.new
      end

      def refund_step_one_page
        @refund_step_one_page ||= Refunds::StepOnePage.new
      end

      def refund_applicant_page
        @refund_applicant_page ||= Refunds::ApplicantPage.new
      end

      def refund_original_case_details_page
        @refund_original_case_details_page ||= Refunds::OriginalCaseDetailsPage.new
      end

      def refund_fees_page
        @refund_fees_page ||= Refunds::FeesPage.new
      end

      def refund_payment_details_page
        @refund_payment_details_page ||= Refunds::PaymentDetailsPage.new
      end

      def refund_review_page
        @refund_review_page ||= Refunds::ReviewPage.new
      end

      def refund_profile_selection_page
        @refund_profile_selection_page ||= Refunds::ProfileSelectionPage.new
      end

      def refund_confirmation_page
        @refund_confirmation_page ||= Refunds::ConfirmationPage.new
      end
    end
  end
end

RSpec.configure do |c|
  c.include ::ET1::Test::PageObjectHelpers
end
