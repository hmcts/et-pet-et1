class AddHasMiscellaneousInformationToClaims < ActiveRecord::Migration[6.1]
  def change
    add_column :claims, :has_miscellaneous_information, :boolean
  end
end
