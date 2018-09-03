class AddSecretToClaims < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :password_digest, :string
  end
end
