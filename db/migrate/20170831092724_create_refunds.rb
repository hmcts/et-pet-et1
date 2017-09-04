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
      t.string   "claimant_title"
      t.string   "claimant_first_name"
      t.string   "claimant_last_name"
      t.string   "claimant_national_insurance"
      t.string   "claimant_date_of_birth"
      t.text     "extra_reference_numbers"
    end
  end
end
