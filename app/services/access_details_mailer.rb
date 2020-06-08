class AccessDetailsMailer
  class << self
    def deliver_later(claim)
      BaseMailer.access_details_email(claim).deliver_later if claim&.user&.email.present?
    end
  end
end
