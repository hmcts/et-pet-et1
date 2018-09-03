class RemoveTelephoneNumberFromRepresentative < ActiveRecord::Migration[4.2]
  def change
    remove_column :representatives, :telephone_number
  end
end
