module AgeValidator

  def date_is_valid
    return if dob_valid_date?

    if date_of_birth.blank?
      add_dob_error_message
    end
  end

  private

  def add_dob_error_message
    errors.add(:date_of_birth, :invalid)
  end

  def dob_valid_date?
    date_of_birth.present? && !date_of_birth.is_a?(Date)
  end
end
