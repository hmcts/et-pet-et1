class AddContactPreferenceToRepresentative < ActiveRecord::Migration
  def change
    add_column :representatives, :contact_preference, :string
  end
end
