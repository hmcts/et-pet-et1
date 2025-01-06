class ConfirmationPresenter < Presenter
  def submission_reference
    I18n.t('claim_confirmations.show.submission_details.reference_number', reference: fee_group_reference)
  end

  def submission_information
    I18n.t 'claim_confirmations.show.submission_details.submission',
           date: date(submitted_at)
  end

  def attachments
    if attachment_filenames.empty?
      I18n.t 'claim_confirmations.show.no_attachments'
    else
      names = []
      attachment_filenames.each_with_index do |f, i|
        names << sanitize(f)
        names << tag.br if i.even?
      end
      safe_join(names)
    end
  end

  private

  def file_separator
    tag.br
  end

  def items
    [:submission_reference, :submission_information, :attachments]
  end

  def attachment_filenames
    @attachment_filenames ||=
      [claim_details_rtf, additional_claimants_csv].
      map { |attachment| FilenameCleaner.for attachment }.compact
  end

  def display_wales_address_in_welsh?
    I18n.locale.to_s == 'cy' && office.name == 'Wales'
  end

end
