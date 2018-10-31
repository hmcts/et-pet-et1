module ET1
  module Test
    module RailsSessionCookieSupport
      def set_rails_session_cookie(value, cookie_options: {})
        key = Rails.application.config.session_options[:key]
        env = Rails.application.env_config.dup
        request = ActionDispatch::Request.new env
        default_cookie_options = {
          path: '/',
          domain: nil,
          expire_after: nil,
          secure: Rails.application.config.session_options[:secure],
          httponly: true,
          defer: false,
          renew: false
        }
        request.cookie_jar.encrypted[key] = default_cookie_options.
          merge(cookie_options).
          merge(value: value.merge(session_id:  SecureRandom.hex(16)))
        page.driver.browser.set_cookie(request.cookie_jar.to_header)
      end
    end
  end
end

RSpec.configure do |c|
  c.include ET1::Test::RailsSessionCookieSupport, type: :request
  c.include ET1::Test::RailsSessionCookieSupport, type: :feature
end
