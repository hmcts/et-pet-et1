class ClaimTransitionManager < TransitionManager
  transition :application_number     => :claimant
  transition :claimant               => :representative
  transition :representative         => :respondent
  transition :respondent             => :employment
  transition :employment             => :claim_type
  transition :claim_type             => :claim_details
  transition :claim_details          => :claim_outcome
  transition :claim_outcome          => :additional_information
  transition :additional_information => :your_fee
  transition :your_fee               => :review
end
