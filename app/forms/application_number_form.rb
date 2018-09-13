class ApplicationNumberForm < Form
  after_save :deliver_access_details

  attribute :password,      :string
  attribute :email_address, :string

  validates :password, presence: true
  validates :email_address, email: true, allow_blank: true

  def target
    resource
  end

  private def deliver_access_details
    AccessDetailsMailer.deliver_later(target)
  end
end
