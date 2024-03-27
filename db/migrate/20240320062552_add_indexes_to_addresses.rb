class AddIndexesToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_index :addresses, [:addressable_type, :addressable_id]
  end
end
