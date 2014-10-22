class MemorableWordForm < Form
  
  attributes :password, :email_address
  validates :password, presence: true

  def target
    resource
  end

  def save
    super && deliver_access_details { and_allow_form_to_save = true }
  end

  private def deliver_access_details &block
    AccessDetailsMailer.deliver_later(target)
    yield
  end
end