class AddEmailAddressToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :email_address, :string
  end
end
