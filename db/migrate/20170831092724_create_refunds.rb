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
    end
  end
end
