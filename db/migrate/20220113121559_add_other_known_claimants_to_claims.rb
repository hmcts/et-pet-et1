class AddOtherKnownClaimantsToClaims < ActiveRecord::Migration[6.1]
  def change
    add_column :claims, :other_known_claimants, :boolean
  end
end
