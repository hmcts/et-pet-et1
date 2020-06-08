class BaseMailer < ActionMailer::Base
  helper :claims

  def access_details_email(claim)
    @claim = claim

    mail(to: @claim.user.email, subject: t('base_mailer.access_details_email.subject'))
  end
end
