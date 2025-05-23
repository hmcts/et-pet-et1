require 'rails_helper'

describe 'Quick edit', type: :feature do
  include FormMethods

  let(:claim_ready_for_review) { create(:claim, :no_attachments, state: 'created') }

  before do
    fill_in_return_form claim_ready_for_review.reference, 'lollolol'
    visit claim_review_path
  end

  it "editing 'Claimant’s details'" do
    review_page.edit_section('Claimant’s details')
    expect(claimants_details_page).to be_displayed
    claimants_details_page.save_and_continue
    expect(review_page).to be_displayed
  end

  it "editing 'Group claim'" do
    review_page.edit_section('Group claim')
    expect(group_claims_page).to be_displayed
    group_claims_page.save_and_continue
    expect(review_page).to be_displayed
  end

  it "editing 'Representative’s details'" do
    review_page.edit_section('Representative’s details')
    expect(representatives_details_page).to be_displayed
    representatives_details_page.save_and_continue
    expect(review_page).to be_displayed
  end

  it "editing 'Respondent’s details'" do
    review_page.edit_section('Respondent’s details')
    expect(respondents_details_page).to be_displayed
    respondents_details_page.save_and_continue
    expect(review_page).to be_displayed
  end

  it "editing 'Employment details'" do
    review_page.edit_section('Employment details')
    expect(employment_details_page).to be_displayed
    employment_details_page.save_and_continue
    expect(review_page).to be_displayed
  end

  it "editing 'Claim type'" do
    review_page.edit_section('Claim type')
    expect(about_the_claim_page).to be_displayed
    about_the_claim_page.save_and_continue
    expect(review_page).to be_displayed
  end

  it "editing 'Claim details'" do
    review_page.edit_section('Claim details')
    expect(claim_details_page).to be_displayed
    claim_details_page.save_and_continue
    expect(page).to have_current_path "/en/apply/review"
  end

  it "editing 'Claim outcome'", :js do
    review_page.edit_section('Claim outcome')
    expect(claim_outcome_page).to be_displayed
    claim_outcome_page.save_and_continue
    expect(review_page).to be_displayed
  end

  it "editing 'Additional information'", :js do
    review_page.edit_section('Additional information')
    expect(more_about_the_claim_page).to be_displayed
    more_about_the_claim_page.save_and_continue
    expect(review_page).to be_displayed

  end

end
