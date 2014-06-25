class RemoveTelephoneNumberFromRepresentative < ActiveRecord::Migration
  def change
    remove_column :representatives, :telephone_number
  end
end
