class MigrateHasSpecialNeedsInClaimants < ActiveRecord::Migration[6.1]
  class Claimant < ActiveRecord::Base
    self.table_name = :claimants
  end

  def up
    Claimant.all.each do |claimant|
      claimant.update_columns has_special_needs: claimant.special_needs.present?
    end
  end

  def down
    #do nothing
  end
end
