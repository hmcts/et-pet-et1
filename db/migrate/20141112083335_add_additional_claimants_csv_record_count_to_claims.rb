class AddAdditionalClaimantsCsvRecordCountToClaims < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :additional_claimants_csv_record_count, :integer, default: 0
  end
end
