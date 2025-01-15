# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_08_10_061322) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", precision: nil
    t.string "namespace"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.datetime "updated_at", precision: nil
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "addressable_id"
    t.string "addressable_type"
    t.string "building"
    t.string "country"
    t.string "county"
    t.datetime "created_at", precision: nil
    t.string "locality"
    t.string "post_code"
    t.boolean "primary", default: true
    t.string "street"
    t.string "telephone_number"
    t.datetime "updated_at", precision: nil
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "claimants", id: :serial, force: :cascade do |t|
    t.string "allow_phone_or_video_attendance", default: [], array: true
    t.text "allow_phone_or_video_reason"
    t.boolean "allow_video_attendance"
    t.integer "claim_id"
    t.string "contact_preference"
    t.datetime "created_at", precision: nil
    t.date "date_of_birth"
    t.string "email_address"
    t.string "fax_number"
    t.string "first_name"
    t.string "gender"
    t.boolean "has_special_needs"
    t.string "last_name"
    t.string "mobile_number"
    t.string "other_title"
    t.boolean "primary_claimant", default: false
    t.text "special_needs"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["claim_id"], name: "index_claimants_on_claim_id"
    t.index ["primary_claimant"], name: "index_claimants_on_primary_claimant"
  end

  create_table "claims", id: :serial, force: :cascade do |t|
    t.string "additional_claimants_csv"
    t.integer "additional_claimants_csv_record_count", default: 0
    t.string "application_reference", null: false
    t.string "case_heard_by_preference"
    t.text "case_heard_by_preference_reason"
    t.text "claim_details"
    t.string "claim_details_rtf"
    t.string "confirmation_email_recipients", default: [], array: true
    t.datetime "created_at", precision: nil
    t.integer "desired_outcomes"
    t.integer "discrimination_claims"
    t.string "email_address"
    t.string "fee_group_reference"
    t.boolean "has_miscellaneous_information"
    t.boolean "has_multiple_claimants"
    t.boolean "has_multiple_respondents"
    t.boolean "has_representative"
    t.boolean "is_other_type_of_claim"
    t.boolean "is_unfair_dismissal"
    t.boolean "is_whistleblowing"
    t.text "miscellaneous_information"
    t.text "other_claim_details"
    t.text "other_known_claimant_names"
    t.boolean "other_known_claimants"
    t.text "other_outcome"
    t.string "password_digest"
    t.integer "pay_claims"
    t.string "pdf"
    t.string "pdf_url"
    t.integer "remission_claimant_count", default: 0
    t.boolean "send_claim_to_whistleblowing_entity"
    t.string "state", default: "created"
    t.datetime "submitted_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "was_employed"
    t.string "whistleblowing_regulator_name"
    t.index ["application_reference"], name: "index_claims_on_application_reference", unique: true
  end

  create_table "diversities", id: :serial, force: :cascade do |t|
    t.string "age_group"
    t.string "caring_responsibility"
    t.string "claim_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "disability"
    t.string "ethnicity"
    t.string "ethnicity_subgroup"
    t.string "gender"
    t.string "gender_at_birth"
    t.string "pregnancy"
    t.string "relationship"
    t.string "religion"
    t.string "sex"
    t.string "sexual_identity"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "employments", id: :serial, force: :cascade do |t|
    t.float "average_hours_worked_per_week"
    t.text "benefit_details"
    t.integer "claim_id"
    t.datetime "created_at", precision: nil
    t.string "current_situation"
    t.date "end_date"
    t.boolean "enrolled_in_pension_scheme"
    t.boolean "found_new_job"
    t.integer "gross_pay"
    t.string "job_title"
    t.integer "net_pay"
    t.integer "new_job_gross_pay"
    t.string "new_job_gross_pay_frequency"
    t.date "new_job_start_date"
    t.float "notice_pay_period_count"
    t.string "notice_pay_period_type"
    t.date "notice_period_end_date"
    t.string "pay_period_type"
    t.date "start_date"
    t.datetime "updated_at", precision: nil
    t.boolean "worked_notice_period_or_paid_in_lieu"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "actor"
    t.integer "claim_id"
    t.string "claim_state"
    t.datetime "created_at", precision: nil, null: false
    t.string "event"
    t.string "message"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "offices", id: :serial, force: :cascade do |t|
    t.string "address"
    t.integer "claim_id"
    t.integer "code"
    t.datetime "created_at", precision: nil
    t.string "email"
    t.string "name"
    t.string "telephone"
    t.datetime "updated_at", precision: nil
  end

  create_table "refunds", id: :serial, force: :cascade do |t|
    t.boolean "accept_declaration", default: false, null: false
    t.text "additional_information", null: false
    t.boolean "address_changed", null: false
    t.string "applicant_address_building", null: false
    t.string "applicant_address_county", null: false
    t.string "applicant_address_locality", null: false
    t.string "applicant_address_post_code", null: false
    t.string "applicant_address_street", null: false
    t.string "applicant_address_telephone_number", null: false
    t.date "applicant_date_of_birth"
    t.string "applicant_email_address", null: false
    t.string "applicant_first_name", null: false
    t.string "applicant_last_name", null: false
    t.string "applicant_title", null: false
    t.string "application_reference", null: false
    t.integer "application_reference_number", null: false
    t.boolean "claim_had_representative", null: false
    t.string "claimant_address_building", null: false
    t.string "claimant_address_county", null: false
    t.string "claimant_address_locality", null: false
    t.string "claimant_address_post_code", null: false
    t.string "claimant_address_street", null: false
    t.string "claimant_email_address"
    t.string "claimant_name", null: false
    t.datetime "created_at", precision: nil
    t.text "eat_case_number", null: false
    t.decimal "eat_hearing_fee", precision: 10, scale: 2
    t.string "eat_hearing_fee_currency", default: "GBP"
    t.date "eat_hearing_fee_payment_date"
    t.boolean "eat_hearing_fee_payment_date_unknown"
    t.string "eat_hearing_fee_payment_method"
    t.decimal "eat_issue_fee", precision: 10, scale: 2
    t.string "eat_issue_fee_currency", default: "GBP"
    t.date "eat_issue_fee_payment_date"
    t.boolean "eat_issue_fee_payment_date_unknown"
    t.string "eat_issue_fee_payment_method"
    t.string "et_case_number", null: false
    t.string "et_country_of_claim", null: false
    t.decimal "et_hearing_fee", precision: 10, scale: 2
    t.string "et_hearing_fee_currency", default: "GBP"
    t.date "et_hearing_fee_payment_date"
    t.boolean "et_hearing_fee_payment_date_unknown"
    t.string "et_hearing_fee_payment_method"
    t.decimal "et_issue_fee", precision: 10, scale: 2
    t.string "et_issue_fee_currency", default: "GBP"
    t.date "et_issue_fee_payment_date"
    t.boolean "et_issue_fee_payment_date_unknown"
    t.string "et_issue_fee_payment_method"
    t.decimal "et_reconsideration_fee", precision: 10, scale: 2
    t.string "et_reconsideration_fee_currency", default: "GBP"
    t.date "et_reconsideration_fee_payment_date"
    t.boolean "et_reconsideration_fee_payment_date_unknown"
    t.string "et_reconsideration_fee_payment_method"
    t.string "et_tribunal_office", null: false
    t.boolean "has_name_changed", null: false
    t.string "payment_account_type", null: false
    t.string "payment_bank_account_name"
    t.string "payment_bank_account_number"
    t.string "payment_bank_name"
    t.string "payment_bank_sort_code"
    t.string "payment_building_society_account_name"
    t.string "payment_building_society_account_number"
    t.string "payment_building_society_name"
    t.string "payment_building_society_sort_code"
    t.string "profile_type", null: false
    t.string "representative_address_building", null: false
    t.string "representative_address_county", null: false
    t.string "representative_address_locality", null: false
    t.string "representative_address_post_code", null: false
    t.string "representative_address_street", null: false
    t.string "representative_name", null: false
    t.string "respondent_address_building", null: false
    t.string "respondent_address_county", null: false
    t.string "respondent_address_locality", null: false
    t.string "respondent_address_post_code", null: false
    t.string "respondent_address_street", null: false
    t.string "respondent_name", null: false
    t.datetime "submitted_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
  end

  create_table "representatives", id: :serial, force: :cascade do |t|
    t.integer "claim_id"
    t.string "contact_preference"
    t.datetime "created_at", precision: nil
    t.string "dx_number"
    t.string "email_address"
    t.string "mobile_number"
    t.string "name"
    t.string "organisation_name"
    t.string "type"
    t.datetime "updated_at", precision: nil
  end

  create_table "respondents", id: :serial, force: :cascade do |t|
    t.string "acas_early_conciliation_certificate_number"
    t.integer "claim_id"
    t.datetime "created_at", precision: nil
    t.boolean "has_acas_number"
    t.string "name"
    t.string "no_acas_number_reason"
    t.boolean "primary_respondent", default: false
    t.datetime "updated_at", precision: nil
    t.boolean "worked_at_same_address"
    t.index ["claim_id"], name: "index_respondents_on_claim_id"
    t.index ["primary_respondent"], name: "index_respondents_on_primary_respondent"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.json "data", default: {}
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reference", null: false
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
