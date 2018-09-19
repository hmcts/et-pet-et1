class AddContactPreferenceToRepresentative < ActiveRecord::Migration[4.2]
  def change
    add_column :representatives, :contact_preference, :string
  end
end
