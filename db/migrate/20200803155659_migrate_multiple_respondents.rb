class MigrateMultipleRespondents < ActiveRecord::Migration[6.0]
  class Respondent < ::ActiveRecord::Base
    self.table_name = :respondents
  end

  class Claim < ::ActiveRecord::Base
    self.table_name = :claims
    has_many :secondary_respondents, -> { where primary_respondent: false },
             class_name: "MigrateMultipleRespondents::Respondent"
  end

  def up
    add_index :respondents, :claim_id, unique: false
    add_index :respondents, :primary_respondent, unique: false

    Claim.joins(:secondary_respondents).update_all(has_multiple_respondents: true)
  end

  def down
    remove_index :claimants, :claim_id
    remove_index :claimants, :primary_respondent
    # Pointless undoing the data
  end
end
