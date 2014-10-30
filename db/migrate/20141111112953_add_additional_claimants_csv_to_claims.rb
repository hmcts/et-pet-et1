class AddAdditionalClaimantsCsvToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :additional_claimants_csv, :string
  end
end
