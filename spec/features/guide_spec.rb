require 'rails_helper'

feature 'Guide', type: :feature do
  include FormMethods

  context 'on the page' do
    let(:time_limits_header)          { 'Time limits' }
    let(:acas_header)                 { 'Acas: early conciliation' }
    let(:acas_exceptions_header)      { 'Exceptions to early conciliation' }
    let(:writing_yours_header)        { 'Writing your claim statement' }

    let(:time_limits_link)          { "Time limits" }
    let(:acas_link)                 { "Acas: early conciliation" }
    let(:acas_exceptions_link)      { "Exceptions to early conciliation" }
    let(:writing_yours_link)        { "Writing your claim statement" }

    let(:time_limits_div)           { "#time_limits" }
    let(:acas_div)                  { "#acas_early_conciliation" }
    let(:acas_exceptions_div)       { "#acas_early_conciliation_exceptions" }
    let(:writing_yours_div)         { "#writing_your_claim_statement" }

    before do
      visit guide_path
    end

    scenario "User visits the guides page" do
      expect(page.html).to include(time_limits_header)
      expect(page.html).to include(acas_header)
      expect(page.html).to include(acas_exceptions_header)
      expect(page.html).to include(writing_yours_header)
    end

    scenario "User can click time time_limits_link" do
      expect(page).to have_link(time_limits_link, href: (time_limits_div).to_s)
      expect(page.find(time_limits_div)).not_to be_nil
    end

    scenario "User can click time acas_link" do
      expect(page).to have_link(acas_link, href: (acas_div).to_s)
      expect(page.find(acas_div)).not_to be_nil
    end

    scenario "User can click time acas_exceptions_link" do
      expect(page).to have_link(acas_exceptions_link, href: (acas_exceptions_div).to_s)
      expect(page.find(acas_exceptions_div)).not_to be_nil
    end
  end

  context 'Returning to the form from the guide page' do
    scenario 'Returns to the previous form page' do
      start_claim
      visit claim_claimant_path
      within('aside') { click_link 'Guide' }
      click_link 'Return to form'

      expect(current_path).to eq claim_claimant_path
    end

    scenario 'Returns to the claim review page when editing a claim' do
      start_claim
      review_page.load
      review_page.edit_section('Group claim')
      within('aside') { click_link 'Guide' }
      click_link 'Return to form'

      expect(group_claims_page).to be_displayed
      group_claims_page
        .no_secondary_claimants
        .save_and_continue
      expect(review_page).to be_displayed
    end

    scenario 'Redirects to claim apply path when not referred from current site' do
      visit guide_path
      click_link 'Return to form'

      expect(current_path).to eq apply_path(locale: :en)
    end
  end
end
