class ClaimPagesManager < PageManager
  page  name: 'application-number', number: 1,
        transitions_to: 'claimant'

  page  name: 'claimant', number: 2,
        transitions_to: 'additional-claimants'

  page  name: 'additional-claimants', number: 3,
        transitions_to: 'representative'

  page  name: 'representative', number: 4,
        transitions_to: 'respondent'

  page  name: 'respondent', number: 5,
        transitions_to: 'additional-respondents'

  page  name: 'additional-respondents', number: 6,
        transitions_to: 'employment'

  page  name: 'employment', number: 7,
        transitions_to: 'claim-type'

  page  name: 'claim-type', number: 8,
        transitions_to: 'claim-details'

  page  name: 'claim-details', number: 9,
        transitions_to: 'claim-outcome'

  page  name: 'claim-outcome', number: 10,
        transitions_to: 'additional-information'

  page  name: 'additional-information', number: 11,
        transitions_to: 'your-fee'

  page  name: 'your-fee', number: 12,
        transitions_to: 'review'

  page  name: 'review'
end
