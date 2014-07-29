class AddRemissionToClaimant < ActiveRecord::Migration
  def change
    add_column :claimants, :applying_for_remission, :boolean, default: false
  end
end
