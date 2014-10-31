require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods
  include Messages
  include EpdqMatchers
  include PdfMethods

  context 'along non happy path' do
    scenario 'Create a new application and immediately review' do
      start_claim
      fill_in_password

      visit '/apply/review'

      expect(page).to have_text I18n.t('claim_reviews.show.incomplete_claim_summary')
    end
  end
end
