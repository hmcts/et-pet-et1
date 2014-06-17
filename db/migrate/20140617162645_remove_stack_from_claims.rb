class RemoveStackFromClaims < ActiveRecord::Migration
  def change
    remove_column :claims, :stack
  end
end
