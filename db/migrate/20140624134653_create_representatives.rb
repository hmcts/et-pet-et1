class CreateRepresentatives < ActiveRecord::Migration
  def change
    create_table :representatives do |t|
      t.string :type
      t.string :organisation_name
      t.string :name
      t.string :telephone_number
      t.string :mobile_number
      t.string :email_address
      t.string :dx_number

      t.integer :claim_id
      t.timestamps
    end
  end
end
