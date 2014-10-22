class ClaimDetailsForm < Form
  attributes :claim_details, :other_known_claimant_names

  validates :claim_details, length: { maximum: 5000 }, presence: true
  validates :other_known_claimant_names, length: { maximum: 350 }

  boolean :other_known_claimants

  def other_known_claimants
    @other_known_claimants ||= other_known_claimant_names?
  end
  
  private def target
    resource
  end
end
