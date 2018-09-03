class CreateClaimDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :claim_details do |t|
      t.boolean :is_unfair_dismissal
      t.integer :discrimination_claims
      t.integer :pay_claims
      t.string :other_claim_details
      t.text :claim_details
      t.integer :desired_outcomes
      t.text :other_outcome
      t.text :other_known_claimant_names
      t.boolean :is_whistleblowing
      t.boolean :send_claim_to_whistleblowing_entity
      t.text :miscellaneous_information

      t.integer :claim_id
      t.timestamps
    end
  end
end
