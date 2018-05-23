class RemoveBuildingSocietyFromRefunds < ActiveRecord::Migration
  def up
    remove_column :refunds, :payment_account_type
    remove_column :refunds, :payment_building_society_account_name
    remove_column :refunds, :payment_building_society_name
    remove_column :refunds, :payment_building_society_account_number
    remove_column :refunds, :payment_building_society_sort_code
  end

  def down
    add_column :refunds, :payment_account_type, :string
    add_column :refunds, :payment_building_society_account_name, :string
    add_column :refunds, :payment_building_society_name, :string
    add_column :refunds, :payment_building_society_account_number, :string
    add_column :refunds, :payment_building_society_sort_code, :string
  end
end
