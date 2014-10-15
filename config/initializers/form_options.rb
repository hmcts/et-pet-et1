module FormOptions
  TITLES              = %i<mr mrs ms miss>.freeze
  GENDERS             = %i<male female prefer_not_to_say>.freeze
  CONTACT_PREFERENCES = %i<email post>.freeze
  COUNTRIES           = %i<united_kingdom other>.freeze
  NO_ACAS_REASON = %i<
    joint_claimant_has_acas_number
    acas_has_no_jurisdiction
    employer_contacted_acas
    interim_relief
    claim_against_security_services
  >.freeze
  PAY_PERIODS = %i<weekly monthly>.freeze
  NOTICE_PAY_PERIODS = %i<weeks months>.freeze
  CURRENT_SITUATION = %i<still_employed notice_period employment_terminated>.freeze
  REPRESENTATIVE_TYPES = %i<
    citizen_advice_bureau
    free_representation_unit
    law_centre trade_union
    solicitor
    private_individual
    trade_association
    other>.freeze

end
