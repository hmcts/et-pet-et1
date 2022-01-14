class AddWasEmployedToClaims < ActiveRecord::Migration[6.1]
  def change
    add_column :claims, :was_employed, :boolean
  end
end
