class CreateClaimDetails < ActiveRecord::Migration
  def change
    create_table :claim_details do |t|
      t.boolean :unfairly_dismissed
      t.string :discrimination
      t.string :pay
      t.string :whistleblowing_claim
      t.string :type_of_claims
      t.string :other_complaints
      t.string :want_if_claim_successful
      t.string :compensation_other_outcome
      t.string :similar_claims
      t.string :similar_claims_names
      t.string :additional_information

      t.timestamps
    end
  end
end
