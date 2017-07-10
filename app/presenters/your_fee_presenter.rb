class YourFeePresenter < Presenter
  def seeking_remission
    yes_no remission_claimant_count.positive?
  end

  def fee
    "£#{fee_calculation.application_fee_after_remission}"
  end
end
