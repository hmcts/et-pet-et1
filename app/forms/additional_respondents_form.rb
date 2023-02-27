class AdditionalRespondentsForm < Form
  include ValidateNested
  attribute :has_multiple_respondents, :boolean
  attribute :secondary_respondents
  transient_attributes :secondary_respondents
  validate :validate_associated_records_for_secondary_respondents
  before_validation :remove_secondaries, unless: :has_multiple_respondents
  has_many_forms :secondary_respondents, class_name: '::AdditionalRespondentsForm::RespondentForm'

  validates :has_multiple_respondents, inclusion: [true, false]

  def persisted_attributes
    attributes.except('secondary_respondents')
  end

  private

  def validate_associated_records_for_secondary_respondents
    validate_collection_association(:secondary_respondents)
  end

  def remove_secondaries
    secondary_respondents.clear
  end

  class RespondentForm < Form
    NAME_LENGTH    = 100
    NO_ACAS_REASON = ::RespondentForm::NO_ACAS_REASON

    include AddressAttributes

    attribute :id
    attribute :name,                                       :string
    attribute :acas_early_conciliation_certificate_number, :string
    attribute :no_acas_number_reason,                      :string

    attribute :has_acas_number,                            :boolean

    validates :name, presence: true, length: { maximum: NAME_LENGTH }
    validates :has_acas_number, inclusion: [true, false]
    validates :no_acas_number_reason,
              inclusion: { in: NO_ACAS_REASON, allow_blank: true },
              presence: { unless: -> { has_acas_number? } }
    validates :acas_early_conciliation_certificate_number,
              presence: { if: -> { has_acas_number? } },
              acas: true
  end

end
