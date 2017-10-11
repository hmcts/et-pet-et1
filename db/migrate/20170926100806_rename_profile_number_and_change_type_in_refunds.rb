class RenameProfileNumberAndChangeTypeInRefunds < ActiveRecord::Migration
  def up
    rename_column :refunds, :profile_number, :profile_type
    change_column :refunds, :profile_type, :string
  end
  def down
    rename_column :refunds, :profile_type, :profile_number
    change_column :refunds, :profile_number, :integer, using: 'profile_number::integer'
  end

end
