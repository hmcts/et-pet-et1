module Diversities
  class PregnancyForm < Form
    PREGNANCY = ['yes_answer', 'no_answer', 'prefer-not-to-say'].freeze
    attribute :pregnancy, :string
    validates :pregnancy, presence: true
  end
end
