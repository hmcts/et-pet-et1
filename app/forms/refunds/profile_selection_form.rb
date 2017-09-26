module Refunds
  class ProfileSelectionForm < Form
    attribute :profile_type, String
    validates :profile_type, presence: true
  end
end
