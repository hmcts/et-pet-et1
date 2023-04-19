class BaseMailer < GovukNotifyRails::Mailer
  helper :claims

  def access_details_email(claim)
    return if claim&.user&.email.blank?

    set_template_name "et1-access-details-v1-#{I18n.locale}"
    @claim = claim
    set_personalisation reference: claim.reference,
                        url: new_user_session_url(locale: I18n.locale)

    mail(to: @claim.user.email, subject: t('base_mailer.access_details_email.subject'))
  end
end
