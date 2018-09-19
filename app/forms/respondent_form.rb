class RespondentForm < Form
  include AddressAttributes

  WORK_ADDRESS_ATTRIBUTES = [
    :work_address_building, :work_address_street, :work_address_locality,
    :work_address_county, :work_address_post_code, :work_address_telephone_number
  ].freeze

  NAME_LENGTH    = 100
  NO_ACAS_REASON = [
    'joint_claimant_has_acas_number', 'acas_has_no_jurisdiction',
    'employer_contacted_acas', 'interim_relief'
  ].freeze

  attribute :name,                                       :string
  attribute :acas_early_conciliation_certificate_number, :string
  attribute :no_acas_number_reason,                      :string
  attribute :worked_at_same_address,                     :boolean
  attribute :work_address_building,                      :string
  attribute :work_address_street,                        :string
  attribute :work_address_locality,                      :string
  attribute :work_address_county,                        :string
  attribute :work_address_post_code,                     :string
  attribute :work_address_telephone_number,              :string

  boolean :no_acas_number

  before_validation :reset_acas_number!,  if: :no_acas_number?
  before_validation :reset_work_address!, if: :worked_at_same_address?

  validates :name, presence: true
  validates :work_address_street, :work_address_locality, :work_address_building,
    :work_address_post_code, presence: { unless: -> { worked_at_same_address? } }
  validates :name, length: { maximum: NAME_LENGTH }
  validates :work_address_building,
    :work_address_street,
    length: { maximum: ADDRESS_LINE_LENGTH }
  validates :work_address_locality,
    :work_address_county,
    length: { maximum: LOCALITY_LENGTH }
  validates :work_address_post_code,
    post_code: true, length: { maximum: POSTCODE_LENGTH }
  validates :work_address_telephone_number,
    length: { maximum: PHONE_NUMBER_LENGTH }

  validates :no_acas_number_reason,
    inclusion: { in: NO_ACAS_REASON, allow_blank: true },
    presence: { if: -> { no_acas_number? } }

  validates :acas_early_conciliation_certificate_number,
    presence: { unless: -> { no_acas_number? } },
    acas: true

  before_save :reload_addresses

  def no_acas_number
    @no_acas_number ||= target.persisted? && acas_early_conciliation_certificate_number.blank?
  end

  def target
    resource.primary_respondent || resource.build_primary_respondent
  end

  private

  def reset_acas_number!
    self.acas_early_conciliation_certificate_number = nil
  end

  def reset_work_address!
    WORK_ADDRESS_ATTRIBUTES.each { |a| send "#{a}=", nil }
  end

  def reload_addresses
    target.addresses.reload
  end
end
