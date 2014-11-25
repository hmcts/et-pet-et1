class BaseMailer < ActionMailer::Base
  helper :claims

  def access_details_email(claim)
    @claim = claim
    mail(to: @claim.email_address,
      subject: t('base_mailer.access_details_email.subject', reference: @claim.reference))
  end

  def started_application(claim)
    @claim = claim
    mail(to: @claim.email_address,
      subject: t('base_mailer.started_application.subject', reference: @claim.reference))
  end

  def submitted_application(claim)
    @claim = claim
    mail(to: @claim.email_address,
      subject: t('base_mailer.submitted_application.subject', reference: @claim.reference))
  end

  def unsuccessful_application(claim)
    @claim = claim
    mail(to: @claim.email_address,
      subject: t('base_mailer.unsuccessful_application.subject', reference: @claim.reference))
  end

  def remission(claim)
    @claim = claim
    mail(to: @claim.email_address,
      subject: t('base_mailer.remission.subject', reference: @claim.reference))
  end

  def confirmation_email(claim, email_addresses)
    @claim = claim
    pdf_form = PdfFormBuilder.new(@claim)
    attachments[pdf_form.filename] = pdf_form.to_pdf
    mail(to: email_addresses, subject: t('base_mailer.confirmation_email.subject'))
  end
end
