module Diversities
  class DisabilityForm < Form
    DISABILITY = ['yes_answer', 'no_answer', 'prefer-not-to-say'].freeze

    attribute :disability, String
  end
end
