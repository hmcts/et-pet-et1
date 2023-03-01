require 'rails_helper'

describe 'Dev ops', type: :feature do
  it 'ping controller responds' do
    visit ping_path(format: 'json')

    expect(page.response_headers['Content-Type']).to include "application/json"
  end
end
