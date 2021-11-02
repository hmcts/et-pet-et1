class MigrateMultipleClaimants < ActiveRecord::Migration[6.0]
  class Claimant < ::ActiveRecord::Base
    self.table_name = :claimants
  end

  class Claim < ::ActiveRecord::Base
    self.table_name = :claims
    has_many :secondary_claimants, -> { where primary_claimant: false },
             class_name: "MigrateMultipleClaimants::Claimant"
  end

  def up
    add_index :claimants, :claim_id, unique: false
    add_index :claimants, :primary_claimant, unique: false
    Claim.joins(:secondary_claimants).update_all(has_multiple_claimants: true)
  end

  def down
    remove_index :claimants, :claim_id
    remove_index :claimants, :primary_claimant
    # Pointless undoing the data
  end
end
