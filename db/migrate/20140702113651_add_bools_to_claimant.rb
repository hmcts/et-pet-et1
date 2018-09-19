class AddBoolsToClaimant < ActiveRecord::Migration[4.2]
  def change
    add_column :claimants, :has_representative, :boolean
    add_column :claimants, :has_special_needs,  :boolean
  end
end
