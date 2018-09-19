class AddEmailAddressToClaim < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :email_address, :string
  end
end
