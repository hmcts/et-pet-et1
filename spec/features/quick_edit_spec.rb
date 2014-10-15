require 'rails_helper'

feature 'Quick edit' do
  include FormMethods

  sections = %w<claimant representative respondent employment claim_type claim_details
    claim_outcome additional_information your_fee>

  before { complete_a_claim }

  sections.each do |section|
    scenario "editing '#{I18n.t('claim_reviews.show.sections.' + section)}'" do
      click_link "Edit #{I18n.t('claim_reviews.show.sections.' + section).downcase}"
      expect(page.current_path).to eq "/apply/#{section}"
      click_button 'Save and continue'
      expect(page.current_path).to eq "/apply/review"
    end
  end
end
