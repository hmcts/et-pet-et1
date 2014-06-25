class RemoveTelephoneNumberFromClaimAddTelephonNumberToAddress < ActiveRecord::Migration
  def change
    remove_column :claimants, :telephone_number
    add_column :addresses, :telephone_number, :string
  end
end
