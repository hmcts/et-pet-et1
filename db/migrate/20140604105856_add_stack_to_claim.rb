class AddStackToClaim < ActiveRecord::Migration[4.2]
  def change
    change_table(:claims) do |t|
      t.string :stack, array: true, default: []
    end
  end
end
