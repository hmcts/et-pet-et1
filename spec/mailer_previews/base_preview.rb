class BaseMailerPreview < ActionMailer::Preview
  def access_details_email
    BaseMailer.access_details_email(Claim.last)
  end

  def confirmation_email
    BaseMailer.confirmation_email(Claim.last, 'user@example.com')
  end
end
