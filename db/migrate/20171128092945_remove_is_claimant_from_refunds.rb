class RemoveIsClaimantFromRefunds < ActiveRecord::Migration[4.2]
  def up
    remove_column :refunds, :is_claimant
  end

  def down
    add_column :refunds, :is_claimant, :boolean
  end
end
