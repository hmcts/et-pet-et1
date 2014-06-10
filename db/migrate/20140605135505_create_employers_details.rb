class CreateEmployersDetails < ActiveRecord::Migration
  def change
    create_table :employers_details do |t|
      t.string :name
      t.string :building_name_number
      t.string :street
      t.string :town_city
      t.string :county
      t.string :postcode
      t.string :telephone
      t.string :acas_certificate_number
      t.boolean :acas_number
      t.boolean :work_address_different
      t.boolean :another_employer_same_case
      t.boolean :employed_by_organisation

      t.timestamps
    end
  end
end
