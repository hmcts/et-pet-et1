module Diversities
  class EthnicityForm < Form
    ETHNICITY = ["white", "mixed-multiple-ethnic-groups", "asian-asian-british",
                 "black-african-caribbean-black-british", "other-ethnic-group", "prefer-not-to-say"].freeze
    ETHNICITY_SUBGROUP = {
      "white" =>
        ["english-welsh-scottish-northern-irish-british",
         "irish", "gypsy-or-irish-traveller", "any-other-white-background",
         "none-of-the-above"],
      "mixed-multiple-ethnic-groups" =>
        ["white-and-black-caribbean", "white-and-black-african",
         "white-and-asian", "any-other-mixed-multiple-ethnic-background", "none-of-the-above"],
      "asian-asian-british" =>
        ["indian", "pakistani", "bangladeshi", "chinese", "any-other-asian-background",
         "none-of-the-above"],
      "black-african-caribbean-black-british" =>
        ["african", "caribbean", "any-other-black-african-caribbean-background",
         "none-of-the-above"],
      "other-ethnic-group" =>
        ["arab", "any-other-ethnic-group", "none-of-the-above"]
    }.freeze
    attribute :ethnicity, :string
    attribute :ethnicity_subgroup, :string
    attribute :ethnicity_subgroup_white
    attribute :ethnicity_subgroup_mixed
    attribute :ethnicity_subgroup_asian
    attribute :ethnicity_subgroup_black
    attribute :ethnicity_subgroup_other

    before_validation :calculate_ethnicity_subgroup

    private

    def calculate_ethnicity_subgroup
      return if ethnicity.nil?

      subgroup_method = :"ethnicity_subgroup_#{ethnicity.split('-').first}"
      return unless respond_to?(subgroup_method)

      self.ethnicity_subgroup = send(subgroup_method)
    end

  end
end
