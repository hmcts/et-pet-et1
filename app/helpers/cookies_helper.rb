module CookiesHelper
  def cookie_settings
    JSON.parse cookies.fetch('cookie_setting', '{"essential": true, "usage": false, "seen": false}')
  end
end
