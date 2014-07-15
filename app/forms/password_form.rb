class PasswordForm < Form
  attributes :password, :password_confirmation

  validates :password, confirmation: true
  validates :password_confirmation, presence: { if: -> { password.present? } }

  def target
    resource
  end
end
