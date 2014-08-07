class BaseMailer < ActionMailer::Base
  helper :claims

  def access_details_email(claim, email_address)
    @claim = claim
    mail(to: email_address, subject: t('copy.email.subject', reference: @claim.reference))
  end
end
