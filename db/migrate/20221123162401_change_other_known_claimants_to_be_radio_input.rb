class ChangeOtherKnownClaimantsToBeRadioInput < ActiveRecord::Migration[7.0]
  class Claim < ActiveRecord::Base
    self.table_name = :claims
  end

  def up
    Claim.all.each do |claim|
      claim.update_columns other_known_claimants: claim.other_known_claimants
    end
  end

  def down
    Claim.all.each do |claim|
      claim.update_columns other_known_claimants: claim.other_known_claimant_names.present?
    end
  end
end
