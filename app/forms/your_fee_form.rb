class YourFeeForm < Form
  attribute :applying_for_remission, Boolean

  def target
    resource.primary_claimant || resource.build_primary_claimant
  end
end
