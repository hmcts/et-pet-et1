class MigrateOtherKnownClaimantsInClaims < ActiveRecord::Migration[6.1]
  class Claim < ActiveRecord::Base
    self.table_name = :claims
  end

  def up
    Claim.all.each do |claim|
      claim.update_columns other_known_claimants: claim.other_known_claimant_names.present?
    end
  end

  def down
    #do nothing
  end
end
