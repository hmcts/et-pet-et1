class UserSession
  include ActiveModel::Validations, ActiveModel::Model

  attr_accessor :reference, :password, :email_address

  validates :password, :reference, presence: true
  validate :presence_of_claim
  validate :password_authenticates, :claim_not_submitted, if: :claim

  def claim
    @claim ||= Claim.find_by_reference(reference)
  end

  private

  def claim_not_submitted
    if claim.immutable? && claim.authenticate(password)
      errors.add(:base, I18n.t('errors.user_session.immutable'))
    end
  end

  def presence_of_claim
    errors.add(:reference, I18n.t('errors.user_session.not_found')) unless claim
  end

  def password_authenticates
    unless claim.authenticate(password)
      errors.add(:password, I18n.t('errors.user_session.invalid'))
    end
  end
end
