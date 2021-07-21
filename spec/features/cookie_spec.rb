require 'rails_helper'

feature 'Cookies' do
let(:how_we_use_cookies_header)          { 'How cookies are used' }
let(:measuring_website_usage_header)     { 'Measuring website usage (Google Analytics)' }
let(:your_progress)                      { 'Your progress when using the service' }

before do
visit edit_cookies_path
end

scenario "User visits the cookies page" do
  expect(page.html).to include(how_we_use_cookies_header)
  expect(page.html).to include(measuring_website_usage_header)
  expect(page.html).to include(your_progress)
end

end
