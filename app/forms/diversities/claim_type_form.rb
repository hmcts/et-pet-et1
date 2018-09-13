module Diversities
  class ClaimTypeForm < Form
    CLAIM_TYPES = ["unfair-dismissal-or-constructive-dismissal", "discrimination", "redundancy-payment",
                   "other-payments-you-are-owed", "other-complaints"].freeze
    attribute :claim_type, :string
  end
end
