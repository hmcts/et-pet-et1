class PasswordForm < Form
  attributes :password, :password_confirmation

  validates :password, confirmation: true
  validates :password_confirmation, presence: { if: -> { password.present? } }

  def save
    if valid?
      resource.update_attributes attributes
      resource.save
    end
  end
end
