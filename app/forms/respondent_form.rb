class RespondentForm < Form
  include AddressAttributes

  attributes :organisation_name, :name,
             :work_address_building,
             :work_address_street, :work_address_locality,
             :work_address_county, :work_address_post_code,
             :work_address_telephone_number,
             :acas_early_conciliation_certificate_number,
             :no_acas_number_reason, :worked_at_same_address

  booleans   :no_acas_number

  validates :name, presence: true

  validates :work_address_street, :work_address_locality, :work_address_building,
            :work_address_post_code, presence: { unless: -> { worked_at_same_address } }

  validates :name, length: { maximum: NAME_LENGTH }
  validates :work_address_building,
            :work_address_street,
            length: { maximum: ADDRESS_LINE_LENGTH }
  validates :work_address_locality,
            :work_address_county,
            length: { maximum: LOCALITY_LENGTH }
  validates :work_address_post_code, post_code: true, length: { maximum: POSTCODE_LENGTH }
  validates :work_address_telephone_number,
            length: { maximum: PHONE_NUMBER_LENGTH }

  validates :no_acas_number_reason,
    inclusion: { in: FormOptions::NO_ACAS_REASON.map(&:to_s), allow_blank: true },
    presence: { if: -> { no_acas_number? } }

  validates :acas_early_conciliation_certificate_number,
    presence: { unless: -> { no_acas_number? } }

  def no_acas_number
    @no_acas_number ||= target.persisted? && acas_early_conciliation_certificate_number.blank?
  end

  def was_employed
    @was_employed ||= resource.employment.present?
  end

  private def target
    resource.primary_respondent || resource.build_primary_respondent
  end
end
