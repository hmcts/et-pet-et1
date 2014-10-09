class YourFeeForm < Form
  
  attributes :applying_for_remission

  private def target
    resource.primary_claimant || resource.build_primary_claimant
  end
end