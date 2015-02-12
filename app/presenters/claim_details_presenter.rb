class ClaimDetailsPresenter < Presenter
  def claim_details
    simple_format target.claim_details
  end

  def other_known_claimant_names
    simple_format target.other_known_claimant_names
  end

  def attached_document
    CarrierwaveFilename.for claim_details_rtf
  end
end
