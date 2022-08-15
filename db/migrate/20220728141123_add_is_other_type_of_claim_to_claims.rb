class AddIsOtherTypeOfClaimToClaims < ActiveRecord::Migration[7.0]
  def change
    add_column :claims, :is_other_type_of_claim, :boolean
  end
end
