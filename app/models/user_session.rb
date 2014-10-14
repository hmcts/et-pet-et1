class UserSession < PlainModel
  attr_accessor :reference, :password, :email_address

  validates :reference, presence: true
  validates :password, presence: true
  validate :authenticates

  def claim
    Claim.find_by_reference(reference)
  end

  def persisted?
    reference.present?
  end

  private

  def authenticates
    if claim
      if password.present? && claim.password_digest.present? && !claim.authenticate(password)
        errors.add(:password, I18n.t('errors.user_session.invalid'))
      end
    else
      errors.add(:reference, I18n.t('errors.user_session.not_found'))
    end
  end
end
