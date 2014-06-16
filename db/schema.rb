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

ActiveRecord::Schema.define(version: 20140612103612) do

  create_table "claim_details", force: true do |t|
    t.string   "unfairly_dismissed"
    t.string   "discrimination"
    t.string   "pay"
    t.string   "whistleblowing_claim"
    t.string   "type_of_claims"
    t.string   "other_complaints"
    t.string   "want_if_claim_successful"
    t.string   "compensation_other_outcome"
    t.string   "similar_claims"
    t.string   "similar_claims_names"
    t.string   "additional_information"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "employers_details" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "employment_details", force: true do |t|
    t.string   "job_title"
    t.date     "start_date"
    t.string   "hours_worked"
    t.string   "pay_before_tax"
    t.string   "pay_before_tax_frequency"
    t.string   "take_home_pay"
    t.string   "take_home_pay_frequency"
    t.string   "pension_scheme"
    t.string   "details_of_benefit"
    t.string   "current_situation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "employment_ended"
    t.string   "weeks_paid"
    t.date     "another_job_start_date"
    t.string   "another_job_pay_before_tax"
    t.date     "notice_period_end_date"
    t.string   "weeks_paid_frequency"
    t.string   "worked_period_of_notice"
    t.string   "another_job"
    t.string   "another_job_pay_before_tax_frequency"
  end

  create_table "yourdetails", force: true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "building_number_name"
    t.string   "street"
    t.string   "town_city"
    t.string   "county"
    t.string   "postcode"
    t.string   "telephone"
    t.string   "mobile"
    t.string   "contact_method"
    t.boolean  "disability"
    t.boolean  "help_with_fees"
    t.boolean  "reprasentative"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "yourrepresentatives", force: true do |t|
    t.string   "type_of_representative"
    t.string   "representative_organisation"
    t.string   "representative_name"
    t.string   "building_number_name"
    t.string   "street"
    t.string   "town_city"
    t.string   "county"
    t.string   "postcode"
    t.string   "telephone"
    t.string   "mobile"
    t.string   "email"
    t.string   "dx_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
