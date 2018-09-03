class ChangeOtherClaimDetailsTypeOnClaimDetail < ActiveRecord::Migration[4.2]
  def change
    change_column :claim_details, :other_claim_details, :text
  end
end
