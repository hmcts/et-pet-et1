module SentryHelper
  def sentry_public_meta_tags
    return if Rails.application.config.sentry_public_dsn.blank? || !id_or_application_presence?

    render partial: 'shared/sentry_public_tags',
           locals: {
             sentry_public_dsn: Rails.application.config.sentry_public_dsn,
             data: sentry_public_data
           }
  end

  private

  def sentry_public_data
    { release: Rails.application.config.app_version,
      userId: current_user&.id,
      claimId: claim&.id,
      applicationReference: claim.application_reference,
      reference: claim.fee_group_reference }
  end
end
