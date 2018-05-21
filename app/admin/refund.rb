# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Refund do
  filter :submitted_at

  index download_links: [:csv]

  index do
    selectable_column
    column "Id", :id
    column "Created at", :created_at
    column "Updated at", :updated_at
    column "Applicant email address", :applicant_email_address
    column "Application reference", :application_reference
    column "Application reference number", :application_reference_number
    column "Address changed", :address_changed
    column "Has name changed", :has_name_changed
    column "Profile type", :profile_type
    column "Et country of claim", :et_country_of_claim
    column "Et case number", :et_case_number
    column "Et tribunal office", :et_tribunal_office
    column "Respondent name", :respondent_name
    column "Respondent address building", :respondent_address_building
    column "Respondent address street", :respondent_address_street
    column "Respondent address locality", :respondent_address_locality
    column "Respondent address county", :respondent_address_county
    column "Respondent address post code", :respondent_address_post_code
    column "Claim had representative", :claim_had_representative
    column "Representative name", :representative_name
    column "Representative address building", :representative_address_building
    column "Representative address street", :representative_address_street
    column "Representative address locality", :representative_address_locality
    column "Representative address county", :representative_address_county
    column "Representative address post code", :representative_address_post_code
    column "Claimant name", :claimant_name
    column "Additional information", :additional_information
    column "Claimant address post code", :claimant_address_post_code
    column "Et issue fee", :et_issue_fee
    column "Et issue fee currency", :et_issue_fee_currency
    column "Et issue fee payment method", :et_issue_fee_payment_method
    column "Et hearing fee", :et_hearing_fee
    column "Et hearing fee currency", :et_hearing_fee_currency
    column "Et hearing fee payment method", :et_hearing_fee_payment_method
    column "Eat issue fee", :eat_issue_fee
    column "Eat issue fee currency", :eat_issue_fee_currency
    column "Eat issue fee payment method", :eat_issue_fee_payment_method
    column "Eat hearing fee", :eat_hearing_fee
    column "Eat hearing fee currency", :eat_hearing_fee_currency
    column "Eat hearing fee payment method", :eat_hearing_fee_payment_method
    column "Et reconsideration fee", :et_reconsideration_fee
    column "Et reconsideration fee currency", :et_reconsideration_fee_currency
    column "Et reconsideration fee payment method", :et_reconsideration_fee_payment_method
    column "Applicant address building", :applicant_address_building
    column "Applicant address street", :applicant_address_street
    column "Applicant address locality", :applicant_address_locality
    column "Applicant address county", :applicant_address_county
    column "Applicant address post code", :applicant_address_post_code
    column "Applicant address telephone number", :applicant_address_telephone_number
    column "Applicant first name", :applicant_first_name
    column "Applicant last name", :applicant_last_name
    column "Applicant date of birth", :applicant_date_of_birth
    column "Claimant email address", :claimant_email_address
    column "Applicant title", :applicant_title
    column "Payment account name", :payment_bank_account_name
    column "Payment bank name", :payment_bank_name
    column "Payment bank account number", :payment_bank_account_number
    column "Payment bank sort code", :payment_bank_sort_code
    column "Accept declaration", :accept_declaration
    column "Claimant address building", :claimant_address_building
    column "Claimant address street", :claimant_address_street
    column "Claimant address locality", :claimant_address_locality
    column "Claimant address county", :claimant_address_county
    column "Et issue fee payment date", :et_issue_fee_payment_date
    column "Et issue fee payment date unknown", :et_issue_fee_payment_date_unknown
    column "Et hearing fee payment date", :et_hearing_fee_payment_date
    column "Et hearing fee payment date unknown", :et_hearing_fee_payment_date_unknown
    column "Et reconsideration fee payment date", :et_reconsideration_fee_payment_date
    column "Et reconsideration fee payment date unknown", :et_reconsideration_fee_payment_date_unknown
    column "Eat issue fee payment date", :eat_issue_fee_payment_date
    column "Eat issue fee payment date unknown", :eat_issue_fee_payment_date_unknown
    column "Eat hearing fee payment date", :eat_hearing_fee_payment_date
    column "Eat hearing fee payment date unknown", :eat_hearing_fee_payment_date_unknown
    column "Submitted at", :submitted_at
    column "Eat case number", :eat_case_number
  end

  csv do
    column "Id", &:id
    column "Created at", &:created_at
    column "Updated at", &:updated_at
    column "Applicant email address", &:applicant_email_address
    column "Application reference", &:application_reference
    column "Application reference number", &:application_reference_number
    column "Address changed", &:address_changed
    column "Has name changed", &:has_name_changed
    column "Profile type", &:profile_type
    column "Et country of claim", &:et_country_of_claim
    column "Et case number", &:et_case_number
    column "Et tribunal office", &:et_tribunal_office
    column "Respondent name", &:respondent_name
    column "Respondent address building", &:respondent_address_building
    column "Respondent address street", &:respondent_address_street
    column "Respondent address locality", &:respondent_address_locality
    column "Respondent address county", &:respondent_address_county
    column "Respondent address post code", &:respondent_address_post_code
    column "Claim had representative", &:claim_had_representative
    column "Representative name", &:representative_name
    column "Representative address building", &:representative_address_building
    column "Representative address street", &:representative_address_street
    column "Representative address locality", &:representative_address_locality
    column "Representative address county", &:representative_address_county
    column "Representative address post code", &:representative_address_post_code
    column "Claimant name", &:claimant_name
    column "Additional information", &:additional_information
    column "Claimant address post code", &:claimant_address_post_code
    column "Et issue fee", &:et_issue_fee
    column "Et issue fee currency", &:et_issue_fee_currency
    column "Et issue fee payment method", &:et_issue_fee_payment_method
    column "Et hearing fee", &:et_hearing_fee
    column "Et hearing fee currency", &:et_hearing_fee_currency
    column "Et hearing fee payment method", &:et_hearing_fee_payment_method
    column "Eat issue fee", &:eat_issue_fee
    column "Eat issue fee currency", &:eat_issue_fee_currency
    column "Eat issue fee payment method", &:eat_issue_fee_payment_method
    column "Eat hearing fee", &:eat_hearing_fee
    column "Eat hearing fee currency", &:eat_hearing_fee_currency
    column "Eat hearing fee payment method", &:eat_hearing_fee_payment_method
    column "Et reconsideration fee", &:et_reconsideration_fee
    column "Et reconsideration fee currency", &:et_reconsideration_fee_currency
    column "Et reconsideration fee payment method", &:et_reconsideration_fee_payment_method
    column "Applicant address building", &:applicant_address_building
    column "Applicant address street", &:applicant_address_street
    column "Applicant address locality", &:applicant_address_locality
    column "Applicant address county", &:applicant_address_county
    column "Applicant address post code", &:applicant_address_post_code
    column "Applicant address telephone number", &:applicant_address_telephone_number
    column "Applicant first name", &:applicant_first_name
    column "Applicant last name", &:applicant_last_name
    column "Applicant date of birth", &:applicant_date_of_birth
    column "Claimant email address", &:claimant_email_address
    column "Applicant title", &:applicant_title
    column "Payment account name", &:payment_bank_account_name
    column "Payment bank name", &:payment_bank_name
    column "Payment bank account number", &:payment_bank_account_number
    column "Payment bank sort code", &:payment_bank_sort_code
    column "Accept declaration", &:accept_declaration
    column "Claimant address building", &:claimant_address_building
    column "Claimant address street", &:claimant_address_street
    column "Claimant address locality", &:claimant_address_locality
    column "Claimant address county", &:claimant_address_county
    column "Et issue fee payment date", &:et_issue_fee_payment_date
    column "Et issue fee payment date unknown", &:et_issue_fee_payment_date_unknown
    column "Et hearing fee payment date", &:et_hearing_fee_payment_date
    column "Et hearing fee payment date unknown", &:et_hearing_fee_payment_date_unknown
    column "Et reconsideration fee payment date", &:et_reconsideration_fee_payment_date
    column "Et reconsideration fee payment date unknown", &:et_reconsideration_fee_payment_date_unknown
    column "Eat issue fee payment date", &:eat_issue_fee_payment_date
    column "Eat issue fee payment date unknown", &:eat_issue_fee_payment_date_unknown
    column "Eat hearing fee payment date", &:eat_hearing_fee_payment_date
    column "Eat hearing fee payment date unknown", &:eat_hearing_fee_payment_date_unknown
    column "Submitted at", &:submitted_at
    column "Eat case number", &:eat_case_number
  end
  # no edit, destory, create, etc
  config.clear_action_items!
end
# rubocop:enable Metrics/BlockLength
