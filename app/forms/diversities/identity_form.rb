module Diversities
  class IdentityForm < Form
    SEX = ["male", "female", "prefer-not-to-say"].freeze
    SEXUAL_IDENTITY = ["heterosexual-straight", "gay-lesbian", "bisexual",
                       "other", "prefer-not-to-say"].freeze
    GENDER_AT_BIRTH = ['yes_d', 'no_d', "prefer-not-to-say"].freeze
    GENDER = ["male-including-female-to-male-trans-men", "female-including-male-to-female-trans-women",
              "prefer-not-to-say"].freeze

    attribute :sex, String
    attribute :sexual_identity, String
    attribute :gender_at_birth, String
    attribute :gender, String
  end
end
