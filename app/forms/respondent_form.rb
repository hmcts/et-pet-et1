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
  attribute :has_acas_number,                            :boolean

  before_validation :reset_acas_number!,  unless: :has_acas_number?
  before_validation :reset_work_address!, if: :worked_at_same_address?

  validates :worked_at_same_address, inclusion: [true, false]
  validates :name, presence: true
  validates :work_address_street,
            :work_address_locality,
            :work_address_building,
            :work_address_post_code,
            presence: true,
            if: -> { worked_at_same_address == false }
  validates :name,
            length: { maximum: NAME_LENGTH },
            if: -> { worked_at_same_address == false }
  validates :work_address_building,
            :work_address_street,
            ccd_address: true,
            if: -> { worked_at_same_address == false }
  validates :work_address_locality,
            :work_address_county,
            ccd_address: true,
            if: -> { worked_at_same_address == false }
  validates :work_address_post_code,
            post_code: true,
            length: { maximum: POSTCODE_LENGTH },
            unless: :worked_at_same_address?
  validates :work_address_telephone_number,
            length: { maximum: PHONE_NUMBER_LENGTH },
            ccd_phone: true,
            allow_blank: true,
            if: -> { worked_at_same_address == false }
  validates :work_address_county,
            special_character: true,
            allow_blank: true
  validates :work_address_building,
            special_character: { comma: true, number: true },
            if: -> { worked_at_same_address == false }
  validates :work_address_street,
            numerical_character: true
  validates :work_address_street,
            :work_address_locality,
            special_character: true,
            if: -> { worked_at_same_address == false }
  validates :has_acas_number, inclusion: [true, false]

  validates :no_acas_number_reason,
            inclusion: { in: NO_ACAS_REASON },
            ccd_acas_exemption_reason: { unless: :has_acas_number? },
            presence: true,
            if: :validate_acas_reason_presence

  validates :acas_early_conciliation_certificate_number,
            presence: { if: -> { has_acas_number? } },
            acas: true

  before_save :reload_addresses

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

  def validate_acas_reason_presence
    has_acas_number == false && has_acas_number.is_a?(FalseClass)
  end
end
