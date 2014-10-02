class AdditionalClaimantsForm < Form
  def claimants_attributes=(attributes)
    attributes.each_with_index do |(_, claimant_attributes), index|
      claimant = relation[index] || relation.build

      claimants[index] = AdditionalClaimantsForm::AdditionalClaimant.new(claimant_attributes) do |c|
        c.resource = resource
        c.target   = claimant
      end
    end
  end

  def claimants
    @claimants ||= relation.tap { |c| c.build if c.empty? }.
      map { |c| AdditionalClaimantsForm::AdditionalClaimant.new { |ac| ac.target = c } }
  end

  def save
    claimants.all? &:save
  end

  def errors
    claimants.each_with_object(super) do |claimant, errors|
      errors.add(:claimants, claimant.errors)
    end
  end

  def relation
    resource.secondary_claimants
  end
end
