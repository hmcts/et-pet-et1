class AddEmployedAddressToEmployersDetails < ActiveRecord::Migration
  def change
    add_column :employers_details, :employed_building_name_number, :string
    add_column :employers_details, :employed_street, :string
    add_column :employers_details, :employed_town_city, :string
    add_column :employers_details, :employed_county, :county
    add_column :employers_details, :employed_postcode, :string
    add_column :employers_details, :employed_telephone, :string
  end
end
