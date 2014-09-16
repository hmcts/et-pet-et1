class AddStateToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :state, :string
  end
end
