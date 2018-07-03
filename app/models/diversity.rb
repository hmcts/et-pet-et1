class Diversity < ActiveRecord::Base
  FIELDS = [:claim_type, :sex, :sexual_identity, :age_group, :ethnicity,
            :ethnicity_subgroup, :disability, :caring_responsibility, :gender,
            :gender_at_birth, :pregnancy, :relationship, :religion].freeze

  attr_writer :ethnicity_subgroup_white,
    :ethnicity_subgroup_mixed,
    :ethnicity_subgroup_asian,
    :ethnicity_subgroup_black,
    :ethnicity_subgroup_other

  attr_accessor :religion_text

  def ethinicity_subgroup
    ethnicity_subgroup
  end
  alias ethnicity_subgroup_white ethinicity_subgroup
  alias ethnicity_subgroup_mixed ethinicity_subgroup
  alias ethnicity_subgroup_asian ethinicity_subgroup
  alias ethnicity_subgroup_black ethinicity_subgroup
  alias ethnicity_subgroup_other ethinicity_subgroup

  before_save :fill_religion

  def fill_religion
    self.religion = self.religion_text if self.religion_text.present?
  end
end
