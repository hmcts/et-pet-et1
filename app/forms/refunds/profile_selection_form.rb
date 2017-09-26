module Refunds
  class ProfileSelectionForm < Form
    attribute :profile_type, String
    validates :profile_type, presence: true
    def target
      resource
    end
  end
end
