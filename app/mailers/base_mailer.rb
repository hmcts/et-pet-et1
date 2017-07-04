class BaseMailer < ActionMailer::Base
  helper :claims

  def access_details_email(claim)
    @claim = claim

    mail(to: @claim.email_address, subject: t('base_mailer.access_details_email.subject'))
  end

  def confirmation_email(claim)
    filename = CarrierwaveFilename.for(claim.pdf)
    attachments[filename] = claim.pdf_file.read
    @presenter = ConfirmationEmailPresenter.new(claim)
    mail_subject = t('base_mailer.confirmation_email.subject')
    mail(to: claim.confirmation_email_recipients, subject: mail_subject)
  end
end
