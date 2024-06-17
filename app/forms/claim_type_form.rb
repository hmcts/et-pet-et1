class ClaimTypeForm < Form

  attribute :is_unfair_dismissal,                 :boolean
  attribute :discrimination_claims,               :array_of_strings_type
  attribute :pay_claims,                          :array_of_strings_type
  attribute :is_whistleblowing,                   :boolean
  attribute :send_claim_to_whistleblowing_entity, :boolean
  attribute :is_other_type_of_claim,              :boolean
  attribute :other_claim_details,                 :string
  attribute :whistleblowing_regulator_name,       :string

  before_validation :reset_claim_details!, unless: :is_other_type_of_claim?
  validate :presence_of_at_least_one_claim_type
  validates :other_claim_details, presence: { if: :is_other_type_of_claim }, length: { maximum: 150 }

  private

  def reset_claim_details!
    self.other_claim_details = nil
  end

  def presence_of_at_least_one_claim_type
    attributes.each_key do |attribute_name|
      claim_type = claim_type_value(attribute_name)
      return true if claim_type.present?
    end
    errors.add :base, I18n.t('activemodel.errors.models.claim_type.attributes.blank')
    false
  end

  def claim_type_value(attribute_name)
    claim_type_value = self[attribute_name]
    claim_type_value = claim_type_value.select(&:present?) if claim_type_value.is_a?(Array)
    claim_type_value
  end
end
