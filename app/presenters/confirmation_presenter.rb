class ConfirmationPresenter < Presenter
  def submission_information
    if office.present? && remission_claimant_count.zero?
      submission_with_office_message
    else
      I18n.t 'claim_confirmations.show.submission_details.submission_without_office',
        date: date(submitted_at)
    end
  end

  def payment_failed?
    false
  end

  def attachments
    if attachment_filenames.empty?
      I18n.t 'claim_confirmations.show.no_attachments'
    else
      names = []
      attachment_filenames.each_with_index do |f, i|
        names << sanitize(f)
        names << tag('br') if i.even?
      end
      safe_join(names)
    end
  end

  def payment_amount
    if payment.present?
      number_to_currency target.payment_amount
    else
      I18n.t 'claim_confirmations.show.unprocessable_payment'
    end
  end

  private

  def file_separator
    tag :br
  end

  def items
    [:submission_information, :attachments].tap do |arr|
      arr.delete :payment_amount unless fee_to_pay?
    end
  end

  def attachment_filenames
    @attachment_filenames ||= \
      [claim_details_rtf, additional_claimants_csv].
      map { |attachment| CarrierwaveFilename.for attachment }.compact
  end

  def submission_with_office_message
    if display_wales_address_in_welsh?
     return I18n.t 'claim_confirmations.show.submission_details.submission_with_office_wales', date: date(submitted_at)
    end
    I18n.t 'claim_confirmations.show.submission_details.submission_with_office',
      date: date(submitted_at), office: [office.name, office.address].join(', ')
  end

  def display_wales_address_in_welsh?
    I18n.locale.to_s == 'cy' && office.name == 'Wales'
  end

end
