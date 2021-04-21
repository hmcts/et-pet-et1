class CookiesController < ApplicationController
  include CookiesHelper

  def edit
    @cookie = CookieForm.new(cookie_settings)
  end

  def update
    @cookie = CookieForm.new(cookie_settings)
    @cookie.assign_attributes cookie_params.merge(seen: true)
    cookies['cookie_setting'] = @cookie.to_json
    redirect_to cookies_path, flash: { info: "You've set your cookie preferences"}
  end

  private

  def cookie_params
    params.require(:cookie).permit(:usage)
  end
end
