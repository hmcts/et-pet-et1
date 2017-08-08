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
