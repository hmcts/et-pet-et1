class MigrateHasRepresentativeInClaims < ActiveRecord::Migration[6.1]
  class Claim < ActiveRecord::Base
    self.table_name = :claims
    has_one :representative, class_name: 'MigrateHasRepresentativeInClaims::Representative'
  end

  class Representative < ActiveRecord::Base
    self.table_name = :representatives
    self.inheritance_column = nil
  end

  def up
    Claim.all.each do |claim|
      claim.update_columns has_representative: claim.representative.present?
    end
  end

  def down
    #do nothing
  end
end
