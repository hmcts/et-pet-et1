class AddStateToClaim < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :state, :string
  end
end
