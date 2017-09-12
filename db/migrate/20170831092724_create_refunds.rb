class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.timestamps
      t.string   "password_digest"
      t.string   "email_address"
      t.string   "application_reference", null: false
      t.boolean  "has_address_changed", default: false
      t.boolean  "has_name_changed", default: false
      t.integer  "profile_number"
      t.string   "et_reference_number"
      t.string   "et_case_number"
      t.string   "et_tribunal_office"
      t.string   "respondent_name"
      t.string   "respondent_post_code"
      t.string   "claimant_name"
      t.text     "extra_reference_numbers"
      t.string   "claimant_address_post_code"
      t.integer  "et_issue_fee", default: "GBP"
      t.string   "et_issue_fee_currency"
      t.date     "et_issue_fee_date_paid"
      t.string   "et_issue_fee_payment_method"
      t.integer  "et_hearing_fee"
      t.string   "et_hearing_fee_currency", default: "GBP"
      t.date     "et_hearing_fee_date_paid"
      t.string   "et_hearing_fee_payment_method"
      t.integer  "eat_lodgement_fee"
      t.string   "eat_lodgement_fee_currency", default: "GBP"
      t.date     "eat_lodgement_fee_date_paid"
      t.string   "eat_lodgement_fee_payment_method"
      t.integer  "eat_hearing_fee"
      t.string   "eat_hearing_fee_currency", default: "GBP"
      t.date     "eat_hearing_fee_date_paid"
      t.string   "eat_hearing_fee_payment_method"
      t.integer  "app_reconsideration_fee"
      t.string   "app_reconsideration_fee_currency", default: "GBP"
      t.date     "app_reconsideration_fee_date_paid"
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



    end
  end
end
