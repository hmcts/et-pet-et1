class AddDefaultCountryToAddresses < ActiveRecord::Migration[6.1]
  def change
    change_column_default :addresses, :country, from: nil, to: 'united_kingdom'
  end
end
