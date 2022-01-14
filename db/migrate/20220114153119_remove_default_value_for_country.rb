class RemoveDefaultValueForCountry < ActiveRecord::Migration[6.1]
  def change
    change_column_default :addresses, :country, nil
  end
end
