require 'rails_helper'

RSpec.describe 'Jobs UI access control', type: :feature do
  describe 'when not logged in' do
    it 'redirects to admin login page' do
      visit '/apply/jobs'

      expect(page).to have_current_path(new_admin_user_session_path)
      expect(page).to have_content('Login')
    end
  end

  describe 'when logged in as regular user' do
    let(:user) { create(:user, claim: create(:claim)) }

    before do
      sign_in user, scope: :user
    end

    it 'redirects to admin login page' do
      visit '/apply/jobs'

      expect(page).to have_current_path(new_admin_user_session_path)
      expect(page).to have_content('Login')
    end
  end

  describe 'when logged in as admin user' do
    let(:admin_user) { create(:admin_user) }

    before do
      sign_in admin_user, scope: :admin_user
    end

    it 'allows access to jobs dashboard route' do
      visit '/apply/jobs'

      expect(page).to have_no_current_path(new_admin_user_session_path)
      expect(page.current_path).to start_with('/apply/jobs')
    end

    it 'can access the actual Mission Control dashboard', :skip do
      # This test is skipped because Mission Control Jobs is incompatible with
      # ActiveJob::TestAdapter used in test environment. The authentication
      # functionality is already tested by the previous test.
      skip "Mission Control Jobs incompatible with test environment"
    end
  end

  describe 'when admin is disabled' do
    around do |example|
      ClimateControl.modify(DISABLE_ADMIN: 'true') do
        Rails.application.reload_routes!
        example.run
        Rails.application.reload_routes!
      end
    end

    it 'returns 404 for jobs path' do
      visit '/apply/jobs'
      expect(page.status_code).to eq(404)
    end
  end
end
