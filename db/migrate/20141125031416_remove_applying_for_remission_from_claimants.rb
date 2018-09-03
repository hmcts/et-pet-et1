class RemoveApplyingForRemissionFromClaimants < ActiveRecord::Migration[4.2]
  def change
    remove_column :claimants, :applying_for_remission
  end
end
