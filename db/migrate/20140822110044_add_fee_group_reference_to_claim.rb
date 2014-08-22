class AddFeeGroupReferenceToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :fee_group_reference, :string
  end
end
