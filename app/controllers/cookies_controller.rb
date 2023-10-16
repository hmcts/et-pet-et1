class CookiesController < ApplicationController
  include CookiesHelper
  include ApplicationHelper

  def update
    update_cookie
    redirect_to cookies_path, flash: { info: t('cookie_banner.confirmation_message.cookie_flashes') }
  end

  def create
    update_cookie
    redirect_to path_only(params.dig(:cookie, :return_path)),
                flash: { cookie_banner_confirmation: t("cookie_banner.confirmation_message.#{cookie_form.usage}",
                                                       edit_cookies_path: edit_cookies_path) }
  end

  private

  def update_cookie(cookie_expiry: Rails.application.config.x.cookie_expiry)
    cookie_form.assign_attributes cookie_params.merge(seen: true)
    cookies['cookie_setting'] = { value: cookie_form.to_json, expires: cookie_expiry, secure: Rails.application.config.secure_cookies }
  end

  def cookie_params
    params.require(:cookie).permit(:usage)
  end
end
