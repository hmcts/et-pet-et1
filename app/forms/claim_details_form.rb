class ClaimDetailsForm < Form
  attr_accessor :other_known_claimants

  attributes :claim_details, :other_known_claimant_names

  validates :claim_details, length: { maximum: 5000 }, presence: true
  validates :other_known_claimant_names, length: { maximum: 350 }

  private def target
    resource
  end
end
