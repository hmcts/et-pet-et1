class MigrateWasEmployedInClaims < ActiveRecord::Migration[6.1]
  class Claim < ActiveRecord::Base
    self.table_name = :claims
    has_one :employment, class_name: 'MigrateWasEmployedInClaims::Employment'
  end

  class Employment < ActiveRecord::Base
    self.table_name = :employments
  end

  def up
    Claim.all.each do |claim|
      claim.update_columns was_employed: claim.employment.present?
    end
  end

  def down
    #do nothing
  end
end
