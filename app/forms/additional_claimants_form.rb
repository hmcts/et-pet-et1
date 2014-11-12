class AdditionalClaimantsForm < Form
  boolean :has_additional_claimants

  before_validation :reset_additional_claimants!, unless: :has_additional_claimants

  def has_additional_claimants
    if defined? @has_additional_claimants
      @has_additional_claimants
    else
      @has_additional_claimants = relation.any? &:persisted?
    end
  end

  def claimants_attributes=(attributes)
    attributes.each_with_index do |(_, claimant_attributes), index|
      claimant = relation[index] || relation.build

      claimants[index] = AdditionalClaimantsForm::AdditionalClaimant.new(claimant) do |c|
        c.assign_attributes claimant_attributes
      end
    end
  end

  def claimants
    @claimants ||= relation.tap { |c| c.build if c.empty? }.
      map { |c| AdditionalClaimantsForm::AdditionalClaimant.new(c) }
  end

  def build_child
    @claimants << AdditionalClaimantsForm::AdditionalClaimant.new(relation.build)
  end

  def save
    if valid?
      run_callbacks(:save) { claimants.all?(&:save) }
    else
      false
    end
  end

  def valid?
    run_callbacks(:validation) { super && claimants.map(&:valid?).all? }
  end

  def errors
    claimants.each_with_object(super) do |claimant, errors|
      errors.add(:claimants, claimant.errors)
    end
  end

  private

  def relation
    resource.secondary_claimants
  end

  def reset_additional_claimants!
    relation.destroy_all
    claimants.clear
  end
end
