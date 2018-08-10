module Diversities
  class PregnancyForm < Form
    PREGNANCY = ['yes_d', 'no_d', 'prefer-not-to-say'].freeze
    attribute :pregnancy, String
  end
end
