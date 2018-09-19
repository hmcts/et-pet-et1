class AddAdditionalClaimantsCsvToClaims < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :additional_claimants_csv, :string
  end
end
