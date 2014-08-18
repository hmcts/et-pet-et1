class ClaimForm < Form
  attr_accessor :is_discrimination, :is_pay_related,
    :is_other_type_of_claim, :other_known_claimants

  attributes :discrimination_claims, :pay_claims, :claim_details,
    :other_claim_details, :desired_outcomes, :other_outcome,
    :other_known_claimant_names, :is_whistleblowing,
    :send_claim_to_whistleblowing_entity, :miscellaneous_information,
    :is_unfair_dismissal

  validates :claim_details, :miscellaneous_information, length: { maximum: 5000 }
  validates :other_known_claimant_names, length: { maximum: 350 }
  validates :other_outcome,              length: { maximum: 2500 }

  private def target
    resource
  end
end
