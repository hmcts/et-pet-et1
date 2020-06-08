class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable

  belongs_to :claim, foreign_key: :reference, primary_key: :application_reference, required: true

  validates :password, presence: true, on: :create

  def validate_after_login
    claim_not_submitted
  end

  private

  def claim_not_submitted
    if claim.immutable?
      errors.add(:base, I18n.t('errors.user_session.immutable'))
    end
  end
end
