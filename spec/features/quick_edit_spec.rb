require 'rails_helper'

feature 'Quick edit' do
  include FormMethods

  sections = %w<claimant representative respondent employment claim-type claim-details
    claim-outcome additional-information your-fee>

  before { complete_a_claim }

  sections.each do |section|
    translation = "#{I18n.t('claim_reviews.show.sections.' + section.underscore)}"

    scenario "editing '#{translation}'" do
      click_link "Edit #{translation.downcase}"
      expect(page.current_path).to eq "/apply/#{section}"
      click_button 'Save and continue'
      expect(page.current_path).to eq "/apply/review"
    end
  end
end
