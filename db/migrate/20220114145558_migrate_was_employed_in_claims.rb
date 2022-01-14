class MigrateWasEmployedInClaims < ActiveRecord::Migration[6.1]
  class Claims < ActiveRecord::Base
    self.table_name = :claims
  end

  def up
    Claim.all.each do |was_employed|
      was_employed.update_columns was_employed: was_employed.was_employed.present?
    end
  end

  def down
    #do nothing
  end
end
