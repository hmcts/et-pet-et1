class ClaimOutcomeForm < Form
  attribute :desired_outcomes, :array_of_strings_type
  attribute :other_outcome,    :string

  validates :other_outcome, length: { maximum: 2500 }
end
