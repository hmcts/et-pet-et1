class BaseMailerPreview < ActionMailer::Preview
  def submitted_application
    BaseMailer.submitted_application(Claim.last)
  end

  def unsuccessful_application
    BaseMailer.unsuccessful_application(Claim.last)
  end

  def remission
    BaseMailer.remission(Claim.last)
  end

  def access_details_email
    BaseMailer.access_details_email(Claim.last)
  end

  def confirmation_email
    BaseMailer.confirmation_email(Claim.last, 'user@example.com')
  end
end
