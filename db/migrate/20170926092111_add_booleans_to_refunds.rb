class AddBooleansToRefunds < ActiveRecord::Migration
  def change
    add_column :refunds, :is_claimant, :boolean
  end
end
