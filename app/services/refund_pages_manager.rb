class RefundPagesManager < PageManager
  namespace :refunds
  page 'application-number',
    number: 1,
    transitions_to: 'profile-selection'

  page 'profile-selection',
    number: 2,
    transitions_to: 'claimant'

  page 'claimant',
    number: 3,
    transitions_to: 'original-case-details'

  page 'original-case-details',
    number: 4,
    transitions_to: 'review'

  page 'review'
end
