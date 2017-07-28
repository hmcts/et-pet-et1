require 'rails_helper'

feature 'Quick edit' do
  include FormMethods

  let(:claim_ready_for_review) { create :claim, :no_attachments, state: 'created' }

  before(:each) do
    fill_in_return_form claim_ready_for_review.reference, 'lollolol'
    visit claim_review_path
  end

  sections = %w<claimant additional-claimants representative respondent employment claim-type claim-details
    claim-outcome additional-information>

  sections.each do |section|
    translation = "#{I18n.t('claim_reviews.show.sections.' + section.underscore)}"

    scenario "editing '#{translation}'" do
      within(".#{section}") do
        click_link 'Edit'
      end
      expect(page.current_path).to eq "/apply/#{section}"
      click_button 'Save and continue'
      expect(page.current_path).to eq "/apply/review"
    end
  end
end
