class AddNationalInsuranceToClaimants < ActiveRecord::Migration
  def change
    add_column :claimants, :national_insurance, :string
  end
end
