class MoveFieldsOntoClaim < ActiveRecord::Migration[4.2]
  class ClaimDetail < ActiveRecord::Base; end
  class Claim < ActiveRecord::Base;
    has_one :claim_detail
  end

  announce 'Adding claim detail fields to claim'

  def self.up
    change_table :claims do |t|
      t.boolean  "is_unfair_dismissal"
      t.integer  "discrimination_claims"
      t.integer  "pay_claims"
      t.text     "other_claim_details"
      t.text     "claim_details"
      t.integer  "desired_outcomes"
      t.text     "other_outcome"
      t.text     "other_known_claimant_names"
      t.boolean  "is_whistleblowing"
      t.boolean  "send_claim_to_whistleblowing_entity"
      t.text     "miscellaneous_information"
    end

    Claim.reset_column_information

    announce 'Copying data from claim_details relation to claim'

    Claim.find_each do |claim|
      next unless claim.claim_detail.present?
      claim.update! claim.claim_detail.attributes.except 'id', 'created_at', 'updated_at', 'claim_id'
    end

    announce 'dropping claim_details table'

    drop_table :claim_details
  end
end
