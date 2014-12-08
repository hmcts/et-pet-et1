class ConfirmationEmailPresenter < ConfirmationPresenter
  def office?
    target.office.present?
  end

  def office_details
    [target.office.name, target.office.address].join(', ') if office
  end

  def paid?
    target.payment.present?
  end

  def group?
    target.claimant_count > 1
  end

  def payment_failed?
    fee_to_pay? && !paid?
  end

  def payment_amount
    number_to_currency(paid? ? target.payment_amount : target.application_fee)
  end
end
