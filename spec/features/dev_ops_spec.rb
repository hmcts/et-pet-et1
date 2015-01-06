require 'rails_helper'

feature 'Dev ops', type: :feature do
  scenario 'ping controller responds' do
    visit ping_path(format: 'json')

    expect(page.response_headers['Content-Type']).to include "application/json"
  end
end
