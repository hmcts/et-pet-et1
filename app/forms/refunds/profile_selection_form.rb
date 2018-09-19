module Refunds
  class ProfileSelectionForm < Form
    PROFILE_TYPES = ['claimant_direct_not_reimbursed', 'claimant_via_rep'].freeze
    attribute :profile_type, :string
    validates :profile_type, presence: true, inclusion: { in: PROFILE_TYPES }
  end
end
