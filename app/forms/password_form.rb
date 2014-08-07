class PasswordForm < Form
  attributes :password

  attr_accessor :save_and_return_email

  validates :password, presence: true

  def target
    resource
  end

  def save
    super && mail_access_details
  end

  def mail_access_details
    if save_and_return_email.present?
      BaseMailer.access_details_email(resource, save_and_return_email).deliver
    else
      true
    end
  end
end
