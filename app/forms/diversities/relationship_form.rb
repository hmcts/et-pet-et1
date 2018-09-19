module Diversities
  class RelationshipForm < Form
    RELATIONSHIP = ["single-that-is-never-married-and-never-registered-in-a-same-sex-civil-partnership",
                    "married", "separated-but-still-legally-married",
                    "divorced", "widowed",
                    "in-a-registered-same-sex-civil-partnership",
                    "separated-but-still-legally-in-a-same-sex-civil-partnership",
                    "formerly-in-a-same-sex-civil-partnership-which-is-now-legally-dissolved",
                    "surviving-partner-from-a-same-sex-civil-partnership", "prefer-not-to-say"].freeze

    attribute :relationship, :string
  end
end
