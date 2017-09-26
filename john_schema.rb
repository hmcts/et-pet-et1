t.datetime "created_at", manndatory: true
t.datetime "updated_at", mandatory: false
t.string   "email_address", mandatory: false
t.integer  "application_reference_number", mandatory: true
t.boolean  "address_changed", mandatory: true
t.boolean  "has_name_changed", mandatory: true
t.integer  "profile_number", mandatory: true, notes: "At present will always be 2 - which means the person is a sole claimant who has not been reiumbursed"
t.string   "et_country_of_claim", mandatory: true, possible_values: ['england_and_wales', 'scotland']
t.string   "et_case_number", mandatory: false
t.string   "et_tribunal_office", mandatory: true, possible_values: ['14', '15', '32', '51', '17', '41', '34', '18', '19', '50', '22', '23', '24', '26', '13', '25', '27', '31', '16', '33', '99']
t.string   "respondent_name", mandatory: true
t.string   "respondent_address_building", mandatory: true
t.string   "respondent_address_street", mandatory: true
t.string   "respondent_address_locality", mandatory: false
t.string   "respondent_address_county", mandatory: false
t.string   "respondent_address_post_code", mandatory: false
t.boolean  "claim_had_representative", mandatory: true
t.string   "representative_name", mandatory: true_if_claim_had_representative?
t.string   "representative_address_building", mandatory: true_if_claim_had_representative?
t.string   "representative_address_street", mandatory: true_if_claim_had_representative?
t.string   "representative_address_locality", mandatory: false
t.string   "representative_address_county", mandatory: false
t.string   "representative_address_post_code", mandatory: true_if_claim_had_representative?
t.string   "claimant_name", mandatory: true
t.text     "additional_information", mandatory: false, max_length: 500
t.string   "claimant_address_post_code", mandatory: true
t.integer  "et_issue_fee", mandatory: false
t.string   "et_issue_fee_currency",                   default: "GBP", mandatory: true
t.string   "et_issue_fee_payment_method", true_if_et_issue_fee_present?
t.integer  "et_hearing_fee", mandatory: false
t.string   "et_hearing_fee_currency",                 default: "GBP", mandatory: true
t.string   "et_hearing_fee_payment_method", true_if_et_hearing_fee_present?
t.integer  "eat_issue_fee", mandatory: false
t.string   "eat_issue_fee_currency",                  default: "GBP", mandatory: true
t.string   "eat_issue_fee_payment_method", true_if_eat_issue_fee_present?
t.integer  "eat_hearing_fee", mandatory: false
t.string   "eat_hearing_fee_currency",                default: "GBP", mandatory: true
t.string   "eat_hearing_fee_payment_method", true_if_eat_hearing_fee_present?
t.integer  "et_reconsideration_fee", mandatory: false
t.string   "et_reconsideration_fee_currency",         default: "GBP", mandatory: true
t.string   "et_reconsideration_fee_payment_method", true_if_et_reconsideration_fee_present?
t.string   "applicant_address_building", mandatory: true, max_length: 100
t.string   "applicant_address_street", mandatory: true, max_length: 100
t.string   "applicant_address_locality", mandatory: true, max_length: 100
t.string   "applicant_address_county", mandatory: true, max_length: 100
t.string   "applicant_address_post_code", mandatory: true
t.string   "applicant_address_telephone_number", mandatory: true, max_length: 21
t.string   "applicant_first_name", mandatory: true
t.string   "applicant_last_name", mandatory: true
t.date     "applicant_date_of_birth", mandatory: false
t.string   "applicant_email_address", mandatory: false
t.string   "applicant_title", mandatory: true
t.string   "payment_account_type", mandatory: true, values: ['bank', 'building_society']
t.string   "payment_bank_account_name", mandatory: true_if_payment_account_type_is_bank
t.string   "payment_bank_name", mandatory: true_if_payment_account_type_is_bank
t.string   "payment_bank_account_number", mandatory: true_if_payment_account_type_is_bank, max_length: 8
t.string   "payment_bank_sort_code", mandatory: true_if_payment_account_type_is_bank, max_length: 6
t.string   "payment_building_society_account_name", mandatory: true_if_payment_account_type_is_building_society
t.string   "payment_building_society_name", mandatory: true_if_payment_account_type_is_building_society
t.string   "payment_building_society_account_number", mandatory: true_if_payment_account_type_is_building_society, max_length: 8
t.string   "payment_building_society_sort_code", mandatory: true_if_payment_account_type_is_building_society, max_length: 6
t.string   "payment_building_society_reference", mandatory: false
t.boolean  "accept_declaration",                      default: false, mandatory: true
t.string   "claimant_address_building", mandatory: true
t.string   "claimant_address_street", mandatory: true
t.string   "claimant_address_locality", mandatory: true
t.string   "claimant_address_county", mandatory: true
