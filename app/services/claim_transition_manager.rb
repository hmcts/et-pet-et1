class ClaimTransitionManager < TransitionManager
  transition :password       => :claimant
  transition :claimant       => :representative
  transition :representative => :respondent
  transition :respondent     => :employment
  transition :employment     => :claim_type
  transition :claim_type     => :claim_details
  transition :claim_details  => :claim_outcome
  transition :claim_outcome  => :review
end
