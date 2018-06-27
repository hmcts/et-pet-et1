class DiversityPagesManager < PageManager
  namespace :diversities
  page 'claim-type',
    number: 1,
    transitions_to: 'applicant'

  page 'identity',
    number: 2,
    transitions_to: 'original-case-details'

  page 'relationship',
    number: 3,
    transitions_to: 'fees'

  page 'age-caring',
    number: 4,
    transitions_to: 'bank-details'

  page 'religion',
    number: 5,
    transitions_to: 'review'

  page 'etnicity',
    number: 6,
    transitions_to: 'confirmation'

  page 'etnicity-subgroup',
    number: 6,
    transitions_to: 'confirmation'

  page 'disability',
    number: 6,
    transitions_to: 'confirmation'

  page 'pregnancy',
    number: 6,
    transitions_to: 'confirmation'

  page 'confirmation',
    number: 7
end
