class YourFeePresenter < Presenter
  def subsections
    { your_fee: %i<seeking_remission fee> }
  end

  def seeking_remission
    yes_no remission_claimant_count > 0
  end

  def fee
    "£#{fee_calculation.application_fee_after_remission}"
  end
end
