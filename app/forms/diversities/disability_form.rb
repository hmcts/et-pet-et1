module Diversities
  class DisabilityForm < Form
    DISABILITY = ['yes_d', 'no_d', 'prefer-not-to-say'].freeze

    attribute :disability, String
  end
end
