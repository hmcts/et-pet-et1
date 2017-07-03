class ClaimTypeForm < Form
  boolean :is_other_type_of_claim

  attribute :is_unfair_dismissal,                 Boolean
  attribute :is_protective_award,                 Boolean
  attribute :discrimination_claims,               Array[String]
  attribute :pay_claims,                          Array[String]
  attribute :is_whistleblowing,                   Boolean
  attribute :send_claim_to_whistleblowing_entity, Boolean
  attribute :other_claim_details,                 String

  before_validation :reset_claim_details!, unless: :is_other_type_of_claim?
  validate :presence_of_at_least_one_claim_type

  # rubocop:disable Style/PredicateName
  def is_other_type_of_claim
    self.is_other_type_of_claim = other_claim_details.present?
  end
  # rubocop:enable Style/PredicateName

  private

  def reset_claim_details!
    self.other_claim_details = nil
  end

  def presence_of_at_least_one_claim_type
    attributes.keys.each do |attribute_name|
      claim_type = claim_type_value(attribute_name)
      return true if claim_type.present?
    end

    errors.add :base, I18n.t('activemodel.errors.models.claim_type.attributes.blank')
    false
  end

  def claim_type_value(attribute_name)
    claim_type_value = self[attribute_name]
    if claim_type_value.is_a?(Array)
      claim_type_value = claim_type_value.select(&:present?)
    end
    claim_type_value
  end
end
