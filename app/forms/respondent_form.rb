class RespondentForm < Form
  NO_ACAS_REASON = %i<
    joint_claimant_has_acas_number
    acas_has_no_jurisdiction
    employer_contacted_acas
    interim_relief
    claim_against_security_or_intelligence_services
  >.freeze

  attributes :organisation_name, :name, :address_telephone_number,
             :address_building, :address_street, :address_locality, :address_county,
             :address_post_code, :work_address_building,
             :work_address_street, :work_address_locality,
             :work_address_county, :work_address_post_code,
             :work_address_telephone_number,
             :acas_early_conciliation_certificate_number,
             :no_acas_number_reason, :worked_at_different_address

  booleans   :was_employed, :no_acas_number

  validates :name, :address_building, :address_street,
            :address_locality, :address_post_code, presence: true

  validates :work_address_street, :work_address_locality, :work_address_building,
            :work_address_post_code, presence: { if: -> { worked_at_different_address? } }

  validates :name, length: { maximum: 100 }
  validates :address_building, :address_street, :work_address_building,
            :work_address_street, length: { maximum: 30 }
  validates :address_locality, :address_county, :work_address_locality,
            :work_address_county, length: { maximum: 25 }
  validates :address_post_code, :work_address_post_code, length: { maximum: 8 }
  validates :address_telephone_number, :work_address_telephone_number,
            length: { maximum: 15 }

  validates :no_acas_number_reason,
    inclusion: { in: NO_ACAS_REASON.map(&:to_s), allow_blank: true },
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
    resource.respondents.first || resource.respondents.build
  end

end
