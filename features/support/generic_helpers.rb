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

def test_user
  @test_user || raise("test_user used before it was defined")
end

# rubocop:disable Style/TrivialAccessors
def test_user=(user)
  @test_user = user
end
