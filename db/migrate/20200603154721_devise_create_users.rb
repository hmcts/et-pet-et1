# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :reference, null:false
      t.timestamps null: false
    end

    add_index :users, :email,                unique: false
    add_index :users, :reset_password_token, unique: true
  end
end
