class AdditionalRespondentsForm < BaseForm
  include ValidateNested
  attribute :has_multiple_respondents, :boolean
  attribute :secondary_respondents
  validate :validate_associated_records_for_secondary_respondents
  before_validation :remove_secondaries, unless: :has_multiple_respondents

  def initialize(claim, *args)
    @_resource = claim
    super(*args)
    self.secondary_respondents = [RespondentForm.new]
    self.secondary_respondents_to_delete = []
  end


  def secondary_respondents_attributes=(value)
    to_delete_values, respondent_values = value.values.partition do |attrs|
      attrs = attrs.with_indifferent_access
      attrs['_destroy'].present? && ActiveModel::Type::Boolean.new.cast(attrs['_destroy'])
    end
    self.secondary_respondents = respondent_values.map do |attrs|
      RespondentForm.new(attrs)
    end
    self.secondary_respondents_to_delete = to_delete_values
  end

  def persisted_attributes
    attributes.except('secondary_respondents', 'secondary_respondents_to_delete')
      .merge 'secondary_respondents_attributes' => secondary_respondents.map(&:persisted_attributes) + secondary_respondents_to_delete
  end

  private

  attr_accessor :_resource
  attribute :secondary_respondents_to_delete

  def validate_associated_records_for_secondary_respondents
    validate_collection_association(:secondary_respondents)
  end

  def remove_secondaries
    secondary_respondents.clear
  end

  class RespondentForm < BaseForm
    NAME_LENGTH    = 100
    NO_ACAS_REASON = ::RespondentForm::NO_ACAS_REASON

    include AddressAttributes

    attribute :id
    attribute :name,                                       :string
    attribute :acas_early_conciliation_certificate_number, :string
    attribute :no_acas_number_reason,                      :string

    attribute :no_acas_number,                             :boolean

    validates :name, presence: true, length: { maximum: NAME_LENGTH }
    validates :no_acas_number_reason,
              inclusion: { in: NO_ACAS_REASON, allow_blank: true },
              presence:  { if: -> { no_acas_number? } }
    validates :acas_early_conciliation_certificate_number,
              presence: { unless: -> { no_acas_number? } },
              acas: true

    def persisted_attributes
      attributes.except('id')
    end
  end

end
