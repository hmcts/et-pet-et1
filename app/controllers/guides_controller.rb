class GuidesController < ApplicationController
  delegate :referrer, :host, to: :request

  private

  def return_to_form
    if referrer && host == URI.parse(referrer).host
      referrer
    else
      apply_path
    end
  end

  helper_method :return_to_form
end
