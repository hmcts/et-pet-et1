class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.timestamps
      t.string   "email_address"
      t.string   "application_reference", null: true
      t.integer   "application_reference_number", null: true
      t.boolean  "address_same_as_applicant", default: false
      t.boolean  "has_name_changed", default: false
      t.integer  "profile_number"
      t.string   "et_case_number"
      t.string   "et_tribunal_office"
      t.string   "respondent_name"
      t.string   "respondent_address_building"
      t.string   "respondent_address_street"
      t.string   "respondent_address_locality"
      t.string   "respondent_address_county"
      t.string   "respondent_address_post_code"
      t.string   "respondent_address_country"
      t.string   "representative_name"
      t.string   "representative_address_building"
      t.string   "representative_address_street"
      t.string   "representative_address_locality"
      t.string   "representative_address_county"
      t.string   "representative_address_post_code"
      t.string   "representative_address_country"
      t.string   "claimant_name"
      t.text     "additional_information"
      t.string   "claimant_address_post_code"
      t.integer  "et_issue_fee", default: "GBP"
      t.string   "et_issue_fee_currency"
      t.string   "et_issue_fee_payment_method"
      t.integer  "et_hearing_fee"
      t.string   "et_hearing_fee_currency", default: "GBP"
      t.string   "et_hearing_fee_payment_method"
      t.integer  "eat_issue_fee"
      t.string   "eat_issue_fee_currency", default: "GBP"
      t.string   "eat_issue_fee_payment_method"
      t.integer  "eat_hearing_fee"
      t.string   "eat_hearing_fee_currency", default: "GBP"
      t.string   "eat_hearing_fee_payment_method"
      t.integer  "app_reconsideration_fee"
      t.string   "app_reconsideration_fee_currency", default: "GBP"
      t.string   "app_reconsideration_fee_payment_method"
      t.string   "applicant_address_building"
      t.string   "applicant_address_street"
      t.string   "applicant_address_locality"
      t.string   "applicant_address_county"
      t.string   "applicant_address_post_code"
      t.string   "applicant_address_telephone_number"
      t.string   "applicant_address_country"
      t.string   "applicant_first_name"
      t.string   "applicant_last_name"
      t.date     "applicant_date_of_birth"
      t.string   "applicant_email_address"
      t.string   "applicant_title"
      t.string   "payment_account_type"
      t.string   "payment_account_name"
      t.string   "payment_bank_name"
      t.string   "payment_account_number"
      t.string   "payment_sort_code"
      t.boolean  "accept_declaration", null: false, default: false
      t.string   "claimant_address_building"
      t.string   "claimant_address_street"
      t.string   "claimant_address_locality"
      t.string   "claimant_address_county"
      t.string   "claimant_address_post_code"
      t.string   "claimant_address_country"



    end
  end
end
