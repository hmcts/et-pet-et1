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

def refund_step_two_page
  @refund_step_two_page ||= Refunds::StepTwoPage.new
end

def refund_original_case_details_page
  @refund_original_case_details_page ||= Refunds::OriginalCaseDetailsPage.new
end

def refund_step_five_page
  @refund_step_five_page ||= Refunds::StepFivePage.new
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
  @test_user  || raise("test_user used before it was defined")
end

def test_user=(user)
  @test_user = user
end
