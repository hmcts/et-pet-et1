class RenameWorkedAtDifferentAddress < ActiveRecord::Migration
  def change
    rename_column :respondents, :worked_at_different_address, :worked_at_same_address
    change_column :respondents, :worked_at_same_address, :boolean, default: true
  end
end
