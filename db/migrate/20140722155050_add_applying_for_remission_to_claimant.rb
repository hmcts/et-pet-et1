class AddApplyingForRemissionToClaimant < ActiveRecord::Migration[4.2]
  def change
    add_column :claimants, :applying_for_remission, :boolean, default: false
  end
end
