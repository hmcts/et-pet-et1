class AddRefundIdToClaimants < ActiveRecord::Migration
  def change
    add_column :claimants, :refund_id, :integer
    add_index :claimants, :refund_id
  end
end
