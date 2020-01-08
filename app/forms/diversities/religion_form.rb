module Diversities
  class ReligionForm < Form
    RELIGION = ["no-religion",
                "christian-including-church-of-england-catholic-protestant-and-all-other-christian-denominations",
                "buddhist", "hindu", "jewish", "muslim", "sikh",
                "prefer-not-to-say", "any-other-religion"].freeze

    attribute :religion, :string
    attribute :religion_text, :string
    validates :religion, presence: true
  end
end
