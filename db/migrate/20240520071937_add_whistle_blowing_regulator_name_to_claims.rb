class AddWhistleBlowingRegulatorNameToClaims < ActiveRecord::Migration[7.1]
  def change
    add_column :claims, :whistleblowing_regulator_name, :string
  end
end
