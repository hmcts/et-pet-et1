module AgeValidator

  def older_then_16
    return if dob_valid_date?

    if date_of_birth.blank? || date_of_birth.to_datetime.to_i >= 16.years.ago.to_i
      add_age_error_message
    end
  end

  private

  def add_age_error_message
    message = I18n.t('activemodel.errors.models.claimant.attributes.date_of_birth.too_young')
    errors.add(:date_of_birth, message)
  end

  def dob_valid_date?
    date_of_birth.present? && !date_of_birth.is_a?(Date)
  end
end
