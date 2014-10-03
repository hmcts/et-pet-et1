class ClaimTransitionManager < TransitionManager
  transition :password       => :claimant
  transition :claimant       => :representative
  transition :representative => :respondent
  transition :respondent     => :employment
  transition :employment     => :claim
  transition :claim          => :review
end
