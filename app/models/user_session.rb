class UserSession
  include ActiveModel::Validations, ActiveModel::Model

  attr_accessor :reference, :password, :email_address
  validates_presence_of :password, :reference
  validate :authenticates

  def claim
    @claim ||= Claim.find_by_reference(reference)
  end

  private def authenticates
    if claim
      errors.add(:password, I18n.t('errors.user_session.invalid')) unless claim.authenticate password
    else
      errors.add(:reference, I18n.t('errors.user_session.not_found'))
    end
  end
end