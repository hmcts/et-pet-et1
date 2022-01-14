class MigrateHasRepresentativeInClaims < ActiveRecord::Migration[6.1]
  class Claims < ActiveRecord::Base
    self.table_name = :claims
  end

  def up
    Claim.all.each do |representative|
      representative.update_columns has_representative: representative.has_representative.present?
    end
  end

  def down
    #do nothing
  end
end
