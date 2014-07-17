class ChangeOtherClaimDetailsTypeOnClaimDetail < ActiveRecord::Migration
  def change
    change_column :claim_details, :other_claim_details, :text
  end
end
