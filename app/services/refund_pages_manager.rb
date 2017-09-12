class RefundPagesManager < PageManager
  namespace :refunds
  page 'profile-selection',
    number: 2,
    transitions_to: 'applicant'

  page 'applicant',
    number: 3,
    transitions_to: 'original-case-details'

  page 'original-case-details',
    number: 4,
    transitions_to: 'review'

  page 'review'
end
