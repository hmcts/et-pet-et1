class AddHasRepresentativeToClaims < ActiveRecord::Migration[6.1]
  def change
    add_column :claims, :has_representative, :boolean
  end
end
