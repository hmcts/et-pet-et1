class AdditionalInformationForm < Form
  booleans   :has_miscellaneous_information
  attributes :miscellaneous_information, :attachment, :attachment_cache,
    :remove_attachment

  validates :miscellaneous_information, length: { maximum: 5000 }
  validates :attachment, content_type: {
    in: %w<text/rtf text/plain>,
    message: I18n.t('errors.messages.rtf')
  }

  def valid?
    self.miscellaneous_information = nil unless has_miscellaneous_information?
    super
  end

  def has_attachment?
    resource.attachment_file.present?
  end

  def has_miscellaneous_information
    self.has_miscellaneous_information = miscellaneous_information.present?
  end

  private def target
    resource
  end
end
