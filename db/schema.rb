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

ActiveRecord::Schema.define(version: 20140708231013) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
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
  end

  create_table "claim_details", force: true do |t|
    t.boolean  "is_unfair_dismissal"
    t.integer  "discrimination_claims"
    t.integer  "pay_claims"
    t.string   "other_claim_details"
    t.text     "claim_details"
    t.integer  "desired_outcomes"
    t.text     "other_outcome"
    t.text     "other_known_claimant_names"
    t.boolean  "is_whistleblowing"
    t.boolean  "send_claim_to_whistleblowing_entity"
    t.text     "miscellaneous_information"
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "claimants", force: true do |t|
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
  end

  create_table "claims", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

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

  create_table "representatives", force: true do |t|
    t.string   "type"
    t.string   "organisation_name"
    t.string   "name"
    t.string   "mobile_number"
    t.string   "email_address"
    t.string   "dx_number"
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "respondents", force: true do |t|
    t.string   "name"
    t.string   "acas_early_conciliation_certificate_number"
    t.string   "no_acas_number_reason"
    t.integer  "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
