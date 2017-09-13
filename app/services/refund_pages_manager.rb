class RefundPagesManager < PageManager
  namespace :refunds
  page 'profile-selection',
       number: 1,
       transitions_to: 'applicant'

  page 'applicant',
       number: 2,
       transitions_to: 'original-case-details'

  page 'original-case-details',
       number: 3,
       transitions_to: 'bank-details'

  page 'bank-details',
       number: 4,
       transitions_to: 'review'

  page 'review',
       number: 5,
       transitions_to: 'confirmation'

  page 'confirmation',
       number: 6
end
