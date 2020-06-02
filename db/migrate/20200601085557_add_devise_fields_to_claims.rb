class AddDeviseFieldsToClaims < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :encrypted_password, :string, null: false, default: ""
    add_column :claims, :reset_password_token, :string
    add_column :claims, :reset_password_sent_at, :datetime
    add_index :claims, :reset_password_token, unique: true
  end
end
