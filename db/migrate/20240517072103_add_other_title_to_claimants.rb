class AddOtherTitleToClaimants < ActiveRecord::Migration[7.1]
  def change
    add_column :claimants, :other_title, :string
  end
end
