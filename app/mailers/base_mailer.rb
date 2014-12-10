class BaseMailer < ActionMailer::Base
  helper :claims

  def access_details_email(claim)
    @claim = claim
    mail(to: @claim.email_address,
      subject: t('base_mailer.access_details_email.subject', reference: @claim.reference))
  end

  def confirmation_email(claim, email_addresses)
    claim.generate_pdf!
    attachments[claim.pdf_filename] = claim.pdf_file.read
    @presenter = ConfirmationEmailPresenter.new(claim)

    mail(to: email_addresses, subject: t('base_mailer.confirmation_email.subject'))
  end
end
