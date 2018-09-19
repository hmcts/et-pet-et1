class AdditionalInformationForm < Form
  boolean   :has_miscellaneous_information
  attribute :miscellaneous_information, :string

  before_validation :reset_miscellaneous_information!,
    unless: :has_miscellaneous_information?

  validates :miscellaneous_information, length: { maximum: 2500 }

  def has_miscellaneous_information
    self.has_miscellaneous_information = miscellaneous_information.present?
  end

  private

  def reset_miscellaneous_information!
    self.miscellaneous_information = nil
  end
end
