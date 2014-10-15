class ClaimDetailsPresenter < Presenter
  def subsections
    { claim_details: %i<claim_details other_known_claimant_names> }
  end

  def claim_details
    simple_format target.claim_details
  end

  def other_known_claimant_names
    simple_format target.other_known_claimant_names
  end
end
