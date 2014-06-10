class AddAnotherAddressToEmployersDetails < ActiveRecord::Migration
  def change
    add_column :employers_details, :another_building_name_number, :string
    add_column :employers_details, :another_street, :string
    add_column :employers_details, :another_town_city, :string
    add_column :employers_details, :another_county, :county
    add_column :employers_details, :another_postcode, :string
    add_column :employers_details, :another_telephone, :string
  end
end
