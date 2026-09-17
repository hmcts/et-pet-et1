class CreateFeatureFlagValues < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_flag_values do |t|
      t.string :flag_key, null: false
      t.boolean :value
      t.datetime :valid_from
      t.datetime :valid_to

      t.timestamps
    end
    add_index :feature_flag_values, :flag_key, unique: false

  end
end
