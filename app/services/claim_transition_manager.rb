class ClaimTransitionManager < TransitionManager
  transition 'application-number'     => 'claimant'
  transition 'claimant'               => 'additional-claimants'
  transition 'additional-claimants'   => 'representative'
  transition 'representative'         => 'respondent'
  transition 'respondent'             => 'employment'
  transition 'employment'             => 'claim-type'
  transition 'claim-type'             => 'claim-details'
  transition 'claim-details'          => 'claim-outcome'
  transition 'claim-outcome'          => 'additional-information'
  transition 'additional-information' => 'your-fee'
  transition 'your-fee'               => 'review'
end
