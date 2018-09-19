class AddFeeGroupReferenceToClaim < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :fee_group_reference, :string
  end
end
