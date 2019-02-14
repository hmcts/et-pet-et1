class DropPaymentsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :payments
  end
end
