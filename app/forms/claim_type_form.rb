class ClaimTypeForm < Form
  boolean :is_other_type_of_claim

  attribute :is_unfair_dismissal,                 Boolean
  attribute :discrimination_claims,               Array[String]
  attribute :pay_claims,                          Array[String]
  attribute :is_whistleblowing,                   Boolean
  attribute :send_claim_to_whistleblowing_entity, Boolean
  attribute :other_claim_details,                 String

  before_validation :reset_claim_details!, unless: :is_other_type_of_claim?

  validates_with ClaimTypePresenceValidator

  def is_other_type_of_claim
    self.is_other_type_of_claim = other_claim_details.present?
  end

  private

  def reset_claim_details!
    self.other_claim_details = nil
  end
end
