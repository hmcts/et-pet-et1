# frozen_string_literal: true

ActionMailer::Base.delivery_job = ActionMailer::MailDeliveryJob
notify_config = Rails.application.config.govuk_notify
ActionMailer::Base.add_delivery_method :govuk_notify, GovukNotifyRails::Delivery,
                                       api_key: notify_config.send(:"#{notify_config.mode}_api_key"),
                                       base_url: notify_config.custom_url
