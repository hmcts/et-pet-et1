require 'rails_helper'

feature 'Session Expiry', type: :feature do
  include FormMethods

  context 'within the context of creating a claim' do
    context 'outside of the allocated time frame for a user session' do

      before(:each) { start_claim }

      ClaimPagesManager.page_names.each do |page_name|
        scenario "a user is directed to a session expiry page for page: #{page_name}" do
          travel_to TimeHelper.session_expiry_time do
            visit("#{page_name}")
            expect(page).to have_text 'Session expired'
            expect(current_path).to eq expired_user_session_path
          end
        end
      end

      scenario 'a user is unable to re-enter the form from the expiry page' do
        travel_to TimeHelper.session_expiry_time do
          visit claim_claimant_path
          expect(current_path).to eq expired_user_session_path
          visit claim_claimant_path
          expect(current_path).to eq apply_path
        end
      end
    end
  end

  context 'on the start page of the application' do
    scenario 'a users session does not expire' do
      visit apply_path
      travel_to TimeHelper.session_expiry_time do
        click_button 'Start a claim'
        expect(current_path).to eq claim_application_number_path
      end
    end
  end

end
