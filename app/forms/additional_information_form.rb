class AdditionalInformationForm < Form
  # boolean   :has_miscellaneous_information
  attribute :miscellaneous_information, :string
  attribute :has_miscellaneous_information, :boolean

  before_validation :reset_miscellaneous_information!, unless: :has_miscellaneous_information?

  validates :miscellaneous_information, length: { maximum: 2500 }
  validates :has_miscellaneous_information, inclusion: [true, false]

  private

  def reset_miscellaneous_information!
    self.miscellaneous_information = nil
  end
end
