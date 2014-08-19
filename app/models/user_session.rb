class UserSession < PlainModel
  attr_accessor :reference, :password

  validates :reference, presence: true
  validates :password, presence: true
  validate :authenticates

  def claim
    Claim.find_by_reference(reference)
  end

  private

  def authenticates
    if claim
      if password.present? && !claim.authenticate(password)
        errors.add(:password, I18n.t('errors.user_session.invalid'))
      end
    else
      errors.add(:reference, I18n.t('errors.user_session.not_found'))
    end
  end
end
