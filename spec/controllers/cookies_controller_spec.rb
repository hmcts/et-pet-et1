# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CookiesController do
  describe 'PUT update' do
    it 'redirects to the cookies path' do
      put :update, params: { cookie: { usage: 'analytics' } }
      expect(response).to redirect_to(cookies_path)
    end
  end

  describe 'POST create' do
    it 'redirects to the cookies path' do
      post :create, params: { cookie: { usage: 'analytics', return_path: '/my_return_path' } }
      expect(response).to redirect_to('/my_return_path')
    end
  end
end
