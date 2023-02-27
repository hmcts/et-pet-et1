class DiversityPagesManager < PageManager
  namespace :diversities
  page 'claim-type',
       number: 1,
       transitions_to: 'identity'

  page 'identity',
       number: 2,
       transitions_to: 'relationship'

  page 'relationship',
       number: 3,
       transitions_to: 'age-caring'

  page 'age-caring',
       number: 4,
       transitions_to: 'religion'

  page 'religion',
       number: 5,
       transitions_to: 'ethnicity'

  page 'ethnicity',
       number: 6,
       transitions_to: 'disability'

  page 'disability',
       number: 7,
       transitions_to: 'pregnancy'

  page 'pregnancy',
       number: 8,
       transitions_to: 'review'

  page 'review',
       number: 8,
       transitions_to: 'confirmation'

  page 'confirmation',
       number: 9
end
