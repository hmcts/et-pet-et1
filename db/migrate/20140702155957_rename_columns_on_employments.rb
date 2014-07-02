class RenameColumnsOnEmployments < ActiveRecord::Migration
  def change
    rename_column :employments, :found_new_employment, :found_new_job
  end
end
