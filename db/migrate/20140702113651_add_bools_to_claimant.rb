class AddBoolsToClaimant < ActiveRecord::Migration
  def change
    add_column :claimants, :has_representative, :boolean
    add_column :claimants, :has_special_needs,  :boolean
  end
end
