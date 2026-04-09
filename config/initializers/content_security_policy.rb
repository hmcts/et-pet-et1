# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

require "securerandom"

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri :self
    policy.form_action :self
    policy.frame_ancestors :self
    policy.font_src :self, :data
    policy.img_src :self, :data
    policy.object_src :none
    policy.connect_src :self
    policy.media_src :self
    policy.manifest_src :self
    policy.worker_src :self
    policy.frame_src :self, "https://www.googletagmanager.com"
    policy.script_src :self,
                      "https://www.googletagmanager.com",
                      "https://js-cdn.dynatrace.com"
    policy.style_src :self

    # Allow @vite/client to hot reload javascript/style changes in development.
    if Rails.env.development?
      policy.script_src *policy.script_src, :unsafe_eval, "http://#{ViteRuby.config.host_with_port}"
      policy.style_src *policy.style_src, :unsafe_inline
    end
  end

  config.content_security_policy_nonce_generator = ->(request) { request.env["csp_nonce"] ||= SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w(script-src)
  config.content_security_policy_nonce_auto = true
end
