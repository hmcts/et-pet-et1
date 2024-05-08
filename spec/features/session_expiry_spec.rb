require 'rails_helper'

describe 'Session Expiry', type: :feature do
  include FormMethods

  context 'when within the context of creating a claim' do
    context 'when outside of the allocated time frame for a user session' do

      before { start_claim }

      ClaimPagesManager.page_names.each do |page_name|
        it "a user is directed to a session expiry page for page: #{page_name}" do
          travel_to TimeHelper.session_expiry_time do
            visit(Rails.application.routes.url_helpers.send(:"claim_#{page_name.underscore}_path"))
            expect(page).to have_text 'Session expired'
            expect(page).to have_current_path expired_timeout_session_path(locale: :en), ignore_query: true
          end
        end
      end

      it 'a user is unable to re-enter the form from the expiry page' do
        travel_to TimeHelper.session_expiry_time do
          visit claim_claimant_path
          expect(page).to have_current_path expired_timeout_session_path(locale: :en), ignore_query: true
          visit claim_claimant_path
          expect(page).to have_current_path apply_path, ignore_query: true
        end
      end
    end
  end

  context 'when on the start page of the application' do
    it 'a users session does not expire' do
      visit apply_path
      travel_to TimeHelper.session_expiry_time do
        click_button 'Start a claim'
        expect(page).to have_current_path claim_application_number_path(locale: :en), ignore_query: true
      end
    end
  end

end
