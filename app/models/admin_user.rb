class AdminUser < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :trackable, authentication_keys: [:email]
  def devise_mailer
    Devise::Mailer
  end
end
