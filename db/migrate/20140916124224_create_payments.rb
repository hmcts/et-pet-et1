class CreatePayments < ActiveRecord::Migration[4.2]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.integer :claim_id
      t.string  :reference

      t.timestamps null: false
    end
  end
end
