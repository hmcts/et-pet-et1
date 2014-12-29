require 'rails_helper'

feature 'Maintenance' do
  let(:service_suspended_message)          { '<p>The employment tribunal online service is currently unavailable. Please check back later.</p>' }

  before :each do
    visit maintenance_path
  end

  scenario "User visits the maintenance page" do
    expect(page.html).to include(service_suspended_message)
  end

end
