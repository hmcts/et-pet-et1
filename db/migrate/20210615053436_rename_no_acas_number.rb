class RenameNoAcasNumber < ActiveRecord::Migration[6.1]
  def change
    rename_column :respondents, :no_acas_number, :has_acas_number
  end
end
