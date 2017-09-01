module Refunds
  class ProfileSelectionForm < Form
    PROFILES = [[:profile_1, 1],[:profile_2, 2], [:profile_3, 3]]
    attribute :profile_number, Integer
    def target
      resource
    end
  end
end
