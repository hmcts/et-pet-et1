class RemoveApplyingForRemissionFromClaimants < ActiveRecord::Migration
  def change
    remove_column :claimants, :applying_for_remission
  end
end
