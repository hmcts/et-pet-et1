class AddSecretToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :password_digest, :string
  end
end
