class CreateYourdetails < ActiveRecord::Migration
  def change
    create_table :yourdetails do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :date_of_birth
      t.string :building_number_name
      t.string :street
      t.string :town_city
      t.string :county
      t.string :postcode
      t.string :telephone
      t.string :mobile
      t.string :contact_method
      t.boolean :disability
      t.boolean :help_with_fees
      t.boolean :reprasentative

      t.timestamps
    end
  end
end
