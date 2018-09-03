class AddBooleansToRefunds < ActiveRecord::Migration[4.2]
  def change
    add_column :refunds, :is_claimant, :boolean
  end
end
