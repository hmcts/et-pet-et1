class AddPrimaryClaimantToClaimants < ActiveRecord::Migration
  def change
    add_column :claimants, :primary_claimant, :boolean, default: false
  end
end
