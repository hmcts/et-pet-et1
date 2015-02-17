class AddPrimaryToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :primary, :boolean, default: true
  end
end
