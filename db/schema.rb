# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170926100806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "building"
    t.string   "street"
    t.string   "locality"
    t.string   "county"
    t.string   "post_code"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "telephone_number"
    t.string   "country"
    t.boolean  "primary",          default: true
  end

  create_table "claimants", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "mobile_number"
    t.string   "fax_number"
    t.string   "email_address"
    t.text     "special_needs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "claim_id"
    t.string   "gender"
    t.string   "contact_preference"
    t.string   "title"
    t.boolean  "primary_claimant",   default: false
  end

  create_table "claims", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "is_unfair_dismissal"
    t.integer  "discrimination_claims"
    t.integer  "pay_claims"
    t.text     "other_claim_details"
    t.text     "claim_details"
    t.integer  "desired_outcomes"
    t.text     "other_outcome"
    t.text     "other_known_claimant_names"
    t.boolean  "is_whistleblowing"
    t.boolean  "send_claim_to_whistleblowing_entity"
    t.text     "miscellaneous_information"
    t.string   "fee_group_reference"
    t.string   "state"
    t.datetime "submitted_at"
    t.string   "claim_details_rtf"
    t.string   "email_address"
    t.string   "additional_claimants_csv"
    t.integer  "remission_claimant_count",              default: 0
    t.integer  "additional_claimants_csv_record_count", default: 0
    t.string   "application_reference",                                 null: false
    t.integer  "payment_attempts",                      default: 0
    t.string   "pdf"
    t.string   "confirmation_email_recipients",         default: [],                 array: true
    t.boolean  "is_protective_award",                   default: false
  end

  add_index "claims", ["application_reference"], name: "index_claims_on_application_reference", unique: true, using: :btree

  create_table "employments", force: :cascade do |t|
    t.boolean  "enrolled_in_pension_scheme"
    t.boolean  "found_new_job"
    t.boolean  "worked_notice_period_or_paid_in_lieu"
    t.date     "end_date"
    t.date     "new_job_start_date"
    t.date     "notice_period_end_date"
    t.date     "start_date"
    t.float    "notice_pay_period_count"
    t.integer  "gross_pay"
    t.integer  "net_pay"
    t.integer  "new_job_gross_pay"
    t.float    "average_hours_worked_per_week"
    t.string   "current_situation"
    t.string   "gross_pay_period_type"
    t.string   "job_title"
    t.string   "net_pay_period_type"
    t.string   "new_job_gross_pay_frequency"
    t.string   "notice_pay_period_type"
    t.text     "benefit_details"
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "claim_id"
    t.string   "event"
    t.string   "actor"
    t.string   "message"
    t.string   "claim_state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "offices", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.string   "address"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "claim_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "claim_id"
    t.string   "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refunds", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_address"
    t.string   "application_reference"
    t.integer  "application_reference_number"
    t.boolean  "address_changed"
    t.boolean  "has_name_changed"
    t.string   "profile_type"
    t.string   "et_country_of_claim"
    t.string   "et_case_number"
    t.string   "et_tribunal_office"
    t.string   "respondent_name"
    t.string   "respondent_address_building"
    t.string   "respondent_address_street"
    t.string   "respondent_address_locality"
    t.string   "respondent_address_county"
    t.string   "respondent_address_post_code"
    t.boolean  "claim_had_representative"
    t.string   "representative_name"
    t.string   "representative_address_building"
    t.string   "representative_address_street"
    t.string   "representative_address_locality"
    t.string   "representative_address_county"
    t.string   "representative_address_post_code"
    t.string   "claimant_name"
    t.text     "additional_information"
    t.string   "claimant_address_post_code"
    t.integer  "et_issue_fee"
    t.string   "et_issue_fee_currency",                       default: "GBP"
    t.string   "et_issue_fee_payment_method"
    t.integer  "et_hearing_fee"
    t.string   "et_hearing_fee_currency",                     default: "GBP"
    t.string   "et_hearing_fee_payment_method"
    t.integer  "eat_issue_fee"
    t.string   "eat_issue_fee_currency",                      default: "GBP"
    t.string   "eat_issue_fee_payment_method"
    t.integer  "eat_hearing_fee"
    t.string   "eat_hearing_fee_currency",                    default: "GBP"
    t.string   "eat_hearing_fee_payment_method"
    t.integer  "et_reconsideration_fee"
    t.string   "et_reconsideration_fee_currency",             default: "GBP"
    t.string   "et_reconsideration_fee_payment_method"
    t.string   "applicant_address_building"
    t.string   "applicant_address_street"
    t.string   "applicant_address_locality"
    t.string   "applicant_address_county"
    t.string   "applicant_address_post_code"
    t.string   "applicant_address_telephone_number"
    t.string   "applicant_first_name"
    t.string   "applicant_last_name"
    t.date     "applicant_date_of_birth"
    t.string   "applicant_email_address"
    t.string   "applicant_title"
    t.string   "payment_account_type"
    t.string   "payment_bank_account_name"
    t.string   "payment_bank_name"
    t.string   "payment_bank_account_number"
    t.string   "payment_bank_sort_code"
    t.string   "payment_building_society_account_name"
    t.string   "payment_building_society_name"
    t.string   "payment_building_society_account_number"
    t.string   "payment_building_society_sort_code"
    t.string   "payment_building_society_reference"
    t.boolean  "accept_declaration",                          default: false, null: false
    t.string   "claimant_address_building"
    t.string   "claimant_address_street"
    t.string   "claimant_address_locality"
    t.string   "claimant_address_county"
    t.date     "et_issue_fee_payment_date"
    t.boolean  "et_issue_fee_payment_date_unknown"
    t.date     "et_hearing_fee_payment_date"
    t.boolean  "et_hearing_fee_payment_date_unknown"
    t.date     "et_reconsideration_fee_payment_date"
    t.boolean  "et_reconsideration_fee_payment_date_unknown"
    t.date     "eat_issue_fee_payment_date"
    t.boolean  "eat_issue_fee_payment_date_unknown"
    t.date     "eat_hearing_fee_payment_date"
    t.boolean  "eat_hearing_fee_payment_date_unknown"
    t.boolean  "is_claimant"
  end

  create_table "representatives", force: :cascade do |t|
    t.string   "type"
    t.string   "organisation_name"
    t.string   "name"
    t.string   "mobile_number"
    t.string   "email_address"
    t.string   "dx_number"
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_preference"
  end

  create_table "respondents", force: :cascade do |t|
    t.string   "name"
    t.string   "acas_early_conciliation_certificate_number"
    t.string   "no_acas_number_reason"
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "worked_at_same_address",                     default: true
    t.boolean  "primary_respondent",                         default: false
  end

end
