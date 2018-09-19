class RemoveStackFromClaims < ActiveRecord::Migration[4.2]
  def change
    remove_column :claims, :stack
  end
end
