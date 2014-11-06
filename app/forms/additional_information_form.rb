class AdditionalInformationForm < Form
  boolean   :has_miscellaneous_information

  attribute :miscellaneous_information, String
  attribute :attachment,                AttachmentUploader
  attribute :remove_attachment,         Boolean

  before_validation :reset_miscellaneous_information!, unless: :has_miscellaneous_information?

  delegate :attachment_cache, :attachment_cache=, to: :target

  validates :miscellaneous_information, length: { maximum: 5000 }
  validates :attachment, content_type: {
    in: %w<text/rtf text/plain>,
    message: I18n.t('errors.messages.rtf')
  }

  def has_attachment?
    resource.attachment_file.present?
  end

  def has_miscellaneous_information
    self.has_miscellaneous_information = miscellaneous_information.present?
  end

  private

  def reset_miscellaneous_information!
    self.miscellaneous_information = nil
  end
end
