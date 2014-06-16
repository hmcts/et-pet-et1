class CreateClaimants < ActiveRecord::Migration
  def self.up
    execute "CREATE TYPE gender AS enum('male', 'female');"
    execute "CREATE TYPE contact_preference AS enum('email', 'post', 'fax');"
    execute "CREATE TYPE person_title AS enum('mr', 'mrs', 'miss', 'ms');"

    create_table :claimants do |t|
      t.string :first_name
      t.string :last_name
      t.date   :date_of_birth
      t.string :telephone_number
      t.string :mobile_number
      t.string :fax_number
      t.string :email_address
      t.text   :special_needs

      # custom types
      t.column :title, :person_title
      t.column :gender, :gender
      t.column :contact_preference, :contact_preference

      t.timestamps
      t.references :claim
    end
  end

  def self.down
    drop_table :claimants

    execute "DROP TYPE gender;"
    execute "DROP TYPE contact_preference;"
    execute "DROP TYPE person_title;"
  end
end
