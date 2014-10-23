class UserSession
  include ActiveModel::Validations, ActiveModel::Model

  attr_accessor :reference, :password, :email_address

  validates :password, :reference, presence: true
  validate :presence_of_claim
  validate :password_authenticates, if: :claim

  def claim
    @claim ||= Claim.find_by_reference(reference)
  end

  private 

  def presence_of_claim
    errors.add(:reference, I18n.t('errors.user_session.not_found')) unless claim
  end

  def password_authenticates
    unless claim.authenticate(password)
      errors.add(:password, I18n.t('errors.user_session.invalid'))
    end
  end
end