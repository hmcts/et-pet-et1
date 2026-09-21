class CreateFeatureFlags < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_flags do |t|
      t.string :name
      t.boolean :default_value, default: false
      t.string :key

      t.timestamps
    end
    add_index :feature_flags, :name, unique: true
    add_index :feature_flags, :key, unique: true
  end
end
