require 'rails_helper'

feature 'Maintenance' do
  let(:service_suspended_message)          { '<p>The service is currently suspended.</p>' }

  before :each do
    visit maintenance_path
  end

  scenario "User visits the maintenance page" do
    expect(page.html).to include(service_suspended_message)
  end

end
