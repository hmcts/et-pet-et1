class ConfirmationPresenter < Presenter
  def submitted_at
    date(target.submitted_at)
  end

  def attachments
    attachment_filenames.join tag(:br)
  end

  def payment_amount
    number_to_currency target.payment_amount
  end

  private

  def items
    super.tap do |i|
      i.delete :attachments if attachment_filenames.empty?
      i.delete :payment_amount unless target.payment.present?
    end
  end

  def attachment_filenames
    [attachment, additional_claimants_csv].
      map { |a| a.to_s.split('/').last }.compact
  end
end
