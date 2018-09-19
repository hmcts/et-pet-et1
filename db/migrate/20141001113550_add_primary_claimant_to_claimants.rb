class AddPrimaryClaimantToClaimants < ActiveRecord::Migration[4.2]
  def change
    add_column :claimants, :primary_claimant, :boolean, default: false
  end
end
