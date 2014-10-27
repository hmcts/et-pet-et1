class ClaimTypeForm < Form
  boolean :is_other_type_of_claim

  attributes :is_unfair_dismissal, :discrimination_claims, :pay_claims,
    :is_whistleblowing, :send_claim_to_whistleblowing_entity, :other_claim_details

  before_validation :reset_claim_details!, unless: :is_other_type_of_claim?

  def discrimination_claims
    attributes[:discrimination_claims].map(&:to_s)
  end

  def pay_claims
    attributes[:pay_claims].map(&:to_s)
  end

  def is_other_type_of_claim
    self.is_other_type_of_claim = other_claim_details.present?
  end

  private

  def reset_claim_details!
    self.other_claim_details = nil
  end

  def target
    resource
  end
end
