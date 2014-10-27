class ClaimTypeForm < Form
  attr_accessor :is_other_type_of_claim

  attributes :is_unfair_dismissal, :discrimination_claims, :pay_claims,
    :is_whistleblowing, :send_claim_to_whistleblowing_entity, :other_claim_details

  def discrimination_claims
    attributes[:discrimination_claims].map(&:to_s)
  end

  def pay_claims
    attributes[:pay_claims].map(&:to_s)
  end

  private def target
    resource
  end
end
