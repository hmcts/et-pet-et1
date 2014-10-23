class ConfirmationEmail
  include ActiveModel::Model

  attr_accessor :email_addresses, :additional_email_address

  def initialize
    @additional_email_address = Array.new(5)
  end
end
