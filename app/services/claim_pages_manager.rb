class ClaimPagesManager < PageManager
  page 'application-number',
       number: 1,
       transitions_to: 'claimant'

  page 'claimant',
       number: 2,
       transitions_to: 'case-heard-by'

  page 'case-heard-by',
       number: 3,
       transitions_to: 'additional-claimants'

  page 'additional-claimants',
       number: 4,
       transitions_to: 'representative'

  page 'additional-claimants-upload',
       number: 4,
       transitions_to: 'representative'

  page 'representative',
       number: 5,
       transitions_to: 'respondent'

  page 'respondent',
       number: 6,
       transitions_to: 'additional-respondents'

  page 'additional-respondents',
       number: 7,
       transitions_to: 'employment'

  page 'employment',
       number: 8,
       transitions_to: 'claim-type'

  page 'claim-type',
       number: 9,
       transitions_to: 'claim-details'

  page 'claim-details',
       number: 10,
       transitions_to: 'claim-outcome'

  page 'claim-outcome',
       number: 11,
       transitions_to: 'additional-information'

  page 'additional-information',
       number: 12,
       transitions_to: 'review'

  page 'review'
end
