class ClaimOutcomeForm < Form
  attribute :desired_outcomes, Array[String]
  attribute :other_outcome,    String

  validates :other_outcome, length: { maximum: 2500 }
end
