module Diversities
  class AgeCaringForm < Form
    AGE_GROUP = ['under-25', '25-34', '35-44', '45-54', '55-64', '65-over', 'prefer-not-to-say'].freeze
    CARING_RESPONSIBILITY = ['yes_answer', 'no_answer', 'prefer-not-to-say'].freeze

    attribute :age_group, String
    attribute :caring_responsibility, String
  end
end
