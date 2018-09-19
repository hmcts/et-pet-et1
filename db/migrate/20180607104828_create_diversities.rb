class CreateDiversities < ActiveRecord::Migration[4.2]
  def change
    create_table :diversities do |t|
      t.string :claim_type
      t.string :sex
      t.string :sexual_identity
      t.string :age_group
      t.string :ethnicity
      t.string :ethnicity_subgroup
      t.string :disability
      t.string :caring_responsibility
      t.string :gender
      t.string :gender_at_birth
      t.string :pregnancy
      t.string :relationship
      t.string :religion
      t.timestamps null: false
    end
  end
end
