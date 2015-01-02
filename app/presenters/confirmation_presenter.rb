class ConfirmationPresenter < Presenter
  def submission_information
    if office.present? && remission_claimant_count.zero?
      I18n.t 'claim_confirmations.show.submission_details.submission_with_office',
        date: date(submitted_at), office: [office.name, office.address].join(', ')
    else
      I18n.t 'claim_confirmations.show.submission_details.submission_without_office',
        date: date(submitted_at)
    end
  end

  def payment_failed?
    fee_to_pay? && payment.blank?
  end

  def attachments
    attachment_filenames.map { |f| sanitize(f) }.join(tag :br).html_safe
  end

  def payment_amount
    if payment.present?
      number_to_currency target.payment_amount
    else
      I18n.t 'claim_confirmations.show.unprocessable_payment'
    end
  end

  private

  def items
    %i<submission_information attachments payment_amount>.tap do |arr|
      arr.delete :attachments if attachment_filenames.empty?
      arr.delete :payment_amount unless fee_to_pay?
    end
  end

  def payment_type
    payment_failed? ? :payment_not_processed : :normal
  end

  def attachment_filenames
    [additional_information_rtf, additional_claimants_csv].map(&:filename).compact
  end
end
