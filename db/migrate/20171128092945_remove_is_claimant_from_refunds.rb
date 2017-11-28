class RemoveIsClaimantFromRefunds < ActiveRecord::Migration
  def up
    remove_column :refunds, :is_claimant
  end

  def down
    add_column :refunds, :is_claimant, :boolean
  end
end
