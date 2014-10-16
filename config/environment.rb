# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

sending_host = ENV['SENDING_HOST'] || 'localhost'

ActionMailer::Base.raise_delivery_errors = false
ActionMailer::Base.default_url_options = { host: sending_host, protocol: 'http'}
ActionMailer::Base.default :from => 'no-reply@digital.justice.gov.uk'
ActionMailer::Base.smtp_settings = {
    address: ENV['SMTP_HOSTNAME'] || 'localhost',
    port: ENV['SMTP_PORT'] || 587,
    domain: sending_host,
    user_name: ENV['SMTP_USERNAME'] || '',
    password: ENV['SMTP_PASSWORD'] || '',
    authentication: :login,
    enable_starttls_auto: true
}
