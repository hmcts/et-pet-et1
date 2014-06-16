class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string  :building
      t.string  :street
      t.string  :locality
      t.string  :county
      t.string  :post_code
      t.integer :addressable_id
      t.string  :addressable_type

      t.timestamps
    end
  end
end
