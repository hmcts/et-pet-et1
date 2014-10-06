class AdditionalInformationForm < Form
  booleans   :has_miscellaneous_information
  attributes :miscellaneous_information, :attachment, :attachment_cache,
    :remove_attachment

  validates :miscellaneous_information, length: { maximum: 5000 }

  def save
    if valid?
      self.miscellaneous_information = nil unless has_miscellaneous_information?
      super
    else
      false
    end
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
