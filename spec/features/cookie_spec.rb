require 'rails_helper'

feature 'Cookies' do
  let(:how_we_use_cookies_header)          { '<h2 class="legend">How cookies are used on ATET</h2>' }
  let(:measuring_website_usage_header)     { '<strong>Measuring website usage (Google Analytics)</strong>' }
  let(:our_introductory_message_header)    { '<strong>Our introductory message</strong>' }
  let(:session_header)                     { '<strong>Session</strong>' }

  before :each do
    visit cookies_path
  end

  scenario "User visits the cookies page" do
    expect(page.html).to include(how_we_use_cookies_header)
    expect(page.html).to include(measuring_website_usage_header)
    expect(page.html).to include(our_introductory_message_header)
    expect(page.html).to include(session_header)
  end

end
