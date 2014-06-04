class AddStackToClaim < ActiveRecord::Migration
  def change
    change_table(:claims) do |t|
      t.string :stack, array: true, default: []
    end
  end
end
