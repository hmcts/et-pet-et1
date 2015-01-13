class AdditionalInformationForm < Form
  boolean   :has_miscellaneous_information

  attribute :miscellaneous_information,         String
  attribute :additional_information_rtf,        AttachmentUploader
  attribute :remove_additional_information_rtf, Boolean

  before_validation :reset_miscellaneous_information!, unless: :has_miscellaneous_information?

  delegate :additional_information_rtf_cache, :additional_information_rtf_cache=, to: :target

  validates :miscellaneous_information, length: { maximum: 5000 }
  validates :additional_information_rtf, content_type: {
    in: %w<text/rtf text/plain>,
    message: I18n.t('errors.messages.rtf')
  }, unless: :remove_additional_information_rtf

  def has_additional_information_rtf?
    resource.additional_information_rtf_file.present?
  end

  def has_miscellaneous_information
    self.has_miscellaneous_information = miscellaneous_information.present?
  end

  def attachment_filename
    CarrierwaveFilename.for additional_information_rtf
  end

  private def reset_miscellaneous_information!
    self.miscellaneous_information = nil
  end
end
