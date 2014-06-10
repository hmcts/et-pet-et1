class AddColumnsToEmployersDetails < ActiveRecord::Migration
  def change
    add_column :employers_details, :different_building_name_number, :string
    add_column :employers_details, :different_street, :string
    add_column :employers_details, :different_town_city, :string
    add_column :employers_details, :different_county, :county
    add_column :employers_details, :different_postcode, :string
    add_column :employers_details, :different_telephone, :string
  end
end
