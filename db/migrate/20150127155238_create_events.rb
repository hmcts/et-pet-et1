class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.integer :claim_id
      t.string :event
      t.string :actor
      t.string :message
      t.string :claim_state

      t.timestamps null: false
    end
  end
end
