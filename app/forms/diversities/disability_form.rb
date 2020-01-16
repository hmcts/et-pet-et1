module Diversities
  class DisabilityForm < Form
    DISABILITY = ['yes_answer', 'no_answer', 'prefer-not-to-say'].freeze

    attribute :disability, :string
    validates :disability, presence: true
  end
end
