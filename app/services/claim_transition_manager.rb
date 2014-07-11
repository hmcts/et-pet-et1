class ClaimTransitionManager < TransitionManager
  transition :password       => :claimant
  transition :claimant       => :representative, if: :has_representative
  transition :claimant       => :respondent
  transition :representative => :respondent
  transition :respondent     => :employment,     if: :was_employed
  transition :respondent     => :claim
  transition :employment     => :claim
  transition :claim          => :confirmation
end
