class AddHasSpecialNeedsToClaimants < ActiveRecord::Migration[6.1]
  def change
    add_column :claimants, :has_special_needs, :boolean
  end
end
