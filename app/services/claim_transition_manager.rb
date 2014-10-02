class ClaimTransitionManager < TransitionManager
  transition :password       => :claimant
  transition :claimant       => :representative
  transition :representative => :respondent
  transition :respondent     => :employment,     if: :was_employed
  transition :respondent     => :claim
  transition :employment     => :claim
  transition :claim          => :review
end
