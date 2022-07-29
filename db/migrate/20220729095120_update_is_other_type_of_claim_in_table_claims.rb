class UpdateIsOtherTypeOfClaimInTableClaims < ActiveRecord::Migration[7.0]
  def up
    execute("UPDATE claims SET is_other_type_of_claim = true WHERE other_claim_details IS NOT NULL;")
  end

  def down
  end
end
