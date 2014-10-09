class PasswordForm < Form
  attributes :password

  attr_accessor :save_and_return_email

  validates :password, presence: true

  def target
    resource
  end

  def save
    super && deliver_access_details
  end

  def deliver_access_details
    if save_and_return_email.present?
      BaseMailer.access_details_email(resource, save_and_return_email).deliver_later
    else
      true
    end
  end
end
