class AddRemissionClaimantCountToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :remission_claimant_count, :integer, default: 0
  end
end
