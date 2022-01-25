class MigrateHasMiscellaneousInformationInClaims < ActiveRecord::Migration[6.1]
  class Claims < ActiveRecord::Base
    self.table_name = :claims
  end

  def up
    Claim.all.each do |claim|
      claim.update_columns has_miscellaneous_information: claim.miscellaneous_information.present?
    end
  end

  def down
    #do nothing
  end
end
