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

ActiveRecord::Schema.define(version: 20141212155144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "building",         limit: 255
    t.string   "street",           limit: 255
    t.string   "locality",         limit: 255
    t.string   "county",           limit: 255
    t.string   "post_code",        limit: 255
    t.integer  "addressable_id"
    t.string   "addressable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "telephone_number", limit: 255
    t.string   "country",          limit: 255
  end

  create_table "claimants", force: true do |t|
    t.string   "first_name",         limit: 255
    t.string   "last_name",          limit: 255
    t.date     "date_of_birth"
    t.string   "mobile_number",      limit: 255
    t.string   "fax_number",         limit: 255
    t.string   "email_address",      limit: 255
    t.text     "special_needs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "claim_id"
    t.string   "gender",             limit: 255
    t.string   "contact_preference", limit: 255
    t.string   "title",              limit: 255
    t.boolean  "primary_claimant",               default: false
  end

  create_table "claims", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",                       limit: 255
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
    t.string   "additional_information_rtf"
    t.string   "email_address"
    t.integer  "remission_claimant_count",                          default: 0
    t.string   "additional_claimants_csv"
    t.integer  "additional_claimants_csv_record_count",             default: 0
    t.string   "application_reference",                                          null: false
    t.integer  "payment_attempts",                                  default: 0
    t.string   "pdf"
    t.string   "confirmation_email_recipients",                     default: [],              array: true
  end

  add_index "claims", ["application_reference"], name: "index_claims_on_application_reference", unique: true, using: :btree

  create_table "employments", force: true do |t|
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
    t.string   "current_situation",                    limit: 255
    t.string   "gross_pay_period_type",                limit: 255
    t.string   "job_title",                            limit: 255
    t.string   "net_pay_period_type",                  limit: 255
    t.string   "new_job_gross_pay_frequency",          limit: 255
    t.string   "notice_pay_period_type",               limit: 255
    t.text     "benefit_details"
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offices", force: true do |t|
    t.integer  "code"
    t.string   "name"
    t.string   "address"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "claim_id"
  end

  create_table "payments", force: true do |t|
    t.integer  "amount"
    t.integer  "claim_id"
    t.string   "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "representatives", force: true do |t|
    t.string   "type",               limit: 255
    t.string   "organisation_name",  limit: 255
    t.string   "name",               limit: 255
    t.string   "mobile_number",      limit: 255
    t.string   "email_address",      limit: 255
    t.string   "dx_number",          limit: 255
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_preference", limit: 255
  end

  create_table "respondents", force: true do |t|
    t.string   "name",                                       limit: 255
    t.string   "acas_early_conciliation_certificate_number", limit: 255
    t.string   "no_acas_number_reason",                      limit: 255
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "worked_at_same_address",                                 default: true
    t.boolean  "primary_respondent",                                     default: false
  end

end
