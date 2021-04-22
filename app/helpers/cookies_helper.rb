module CookiesHelper
  def cookie_settings
    JSON.parse cookies.fetch('cookie_setting', '{"essential": true, "usage": false, "seen": false}')
  end

  def cookie_form
    @_cookie_form ||= CookieForm.new(cookie_settings)
  end
end
