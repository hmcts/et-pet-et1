Sentry.init do |config|
  config.dsn = ENV.fetch('RAVEN_DSN', '')
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 1.0
  ENV.fetch('APPVERSION', 'unknown').tap do |version|
    next if version == 'unknown'

    config.release = version
  end

  config.before_send = lambda do |event, _hint|
    # Add claim context for ActiveJob errors
    if event.extra[:active_job] && event.extra[:arguments]&.first&.start_with?('gid://app/Claim/')
      begin
        claim = GlobalID::Locator.locate(event.extra[:arguments].first)
        if claim
          event.user = { id: claim.user.id } if claim.user
          event.extra.merge!(
            claim_id: claim.id,
            application_reference: claim.application_reference,
            reference: claim.fee_group_reference
          )
        end
      rescue StandardError
        # Ignore errors locating the claim
      end
    end
    event
  end
end
