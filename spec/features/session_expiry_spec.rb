require 'rails_helper'

feature 'Session Expiry', type: :feature do
  include FormMethods
  include ActiveSupport::Testing::TimeHelpers

  pages = %w<claimant representative respondent employment claim_type claim_details
    claim_outcome additional_information your_fee review>

  let(:session_expiry_time) { 1.hours.from_now + 1.second }

  context 'within the context of creating a claim' do
    context 'outside of the allocated time frame for a user session' do

      before(:each) { start_claim }

      pages.each do |page_name|
        scenario "a user is directed to a session expiry page for page: #{page_name}" do
          travel_to session_expiry_time do
            visit("#{page_name}")
            expect(page).to have_text "Your Session Has Expired"
          end
        end
      end

    end
  end

  context "on the start page of the application" do
    scenario "a users session doesn't expire" do
      visit "/"
      travel_to session_expiry_time do
        click_button "Start now"
        expect(page).not_to have_text "Your Session Has Expired"
      end
    end
  end

end
