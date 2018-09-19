class CreateClaims < ActiveRecord::Migration[4.2]
  def change
    create_table :claims do |t|
      t.timestamps
    end
  end
end
