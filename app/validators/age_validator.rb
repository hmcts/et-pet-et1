module AgeValidator

  def date_is_valid
    return if dob_valid_date?

    if date_of_birth.blank?
      add_dob_error_message
    end
  end

  private

  def add_dob_error_message
    message = I18n.t('activemodel.errors.models.claimant.attributes.date_of_birth.invalid')
    errors.add(:date_of_birth, message)
  end

  def dob_valid_date?
    date_of_birth.present? && !date_of_birth.is_a?(Date)
  end
end
