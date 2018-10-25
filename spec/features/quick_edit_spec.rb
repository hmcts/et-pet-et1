require 'rails_helper'

feature 'Quick edit' do
  include FormMethods

  let(:claim_ready_for_review) { create :claim, :no_attachments, state: 'created' }

  before do
    fill_in_return_form claim_ready_for_review.reference, 'lollolol'
    visit claim_review_path
  end

  scenario "editing 'Claimant’s details'" do
    within(".claimant") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/claimant"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Group claim'" do
    within(".additional-claimants") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/additional-claimants"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Representative’s details'" do
    within(".representative") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/representative"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Respondent’s details'" do
    within(".respondent") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/respondent"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Employment details'" do
    within(".employment") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/employment"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Claim type'" do
    within(".claim-type") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/claim-type"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Claim details'" do
    within(".claim-details") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/claim-details"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Claim outcome'" do
    within(".claim-outcome") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/claim-outcome"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end

  scenario "editing 'Additional information'" do
    within(".additional-information") do
      click_link 'Edit'
    end
    expect(page.current_path).to eq "/en/apply/additional-information"
    click_button 'Save and continue'
    expect(page.current_path).to eq "/en/apply/review"
  end



end
