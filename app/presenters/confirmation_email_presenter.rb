class ConfirmationEmailPresenter < ConfirmationPresenter
  def payment_information
    t("base_mailer.confirmation_email.intro.#{payment_type}.#{claim_type}")
  end

  def primary_claimant_full_name
    "#{primary_claimant.first_name} #{primary_claimant.last_name}"
  end

  def payment_failed?
    fee_to_pay? && payment.blank?
  end

  private

  def items
    %i<submission_information attachments payment_amount>.tap do |arr|
      arr.delete :payment_amount unless fee_to_pay?
    end
  end

  def payment_type
    payment_failed? ? :payment_not_processed : :normal
  end

  def claim_type
    claimant_count > 1 ? :single : :group
  end
end
