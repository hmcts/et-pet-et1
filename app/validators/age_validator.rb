module AgeValidator
  def older_then_16
    return if self.date_of_birth.blank? || !self.date_of_birth.is_a?(Date)

    if self.date_of_birth.to_datetime.to_i >= 16.years.ago.to_i
      message = I18n.t('activemodel.errors.models.claimant.attributes.date_of_birth.too_young')
      errors.add(:date_of_birth, message)
    end
  end
end
