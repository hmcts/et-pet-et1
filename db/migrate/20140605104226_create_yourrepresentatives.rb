class CreateYourrepresentatives < ActiveRecord::Migration
  def change
    create_table :yourrepresentatives do |t|
      t.string :type_of_representative
      t.string :representative_organisation
      t.string :representative_name
      t.string :building_number_name
      t.string :street
      t.string :town_city
      t.string :county
      t.string :postcode
      t.string :telephone
      t.string :mobile
      t.string :email
      t.string :dx_number

      t.timestamps
    end
  end
end
