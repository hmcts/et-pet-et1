require 'rails_helper'

feature 'Diversity' do

  before do
    visit diversities_path
  end

  scenario "I should be see intro page befor I fill the diversity form" do
    expect(page).to have_text "Diversity monitoring questionnaire"
    expect(page).to have_text "This is optional and won't affect your claim."
    expect(page).to have_text "Your answers will be anonymous. "
  end

  scenario "I can fill the diversity form" do
    expect(page).to have_text "Diversity monitoring questionnaire"
    click_link "Begin this form"

    select "Discrimination", from: 'Claim type'
    select "Male", from: 'Sex (optional)'
    select "Other", from: 'Sexual identity'
    select "Male (including female-to-male trans men)", from: 'Gender (optional)'
    select "Yes", from: 'Gender at birth'

    select "White", from: 'Ethnicity'
    within(:xpath, './/fieldset[@data-name="White"]') do
      select "Irish", from: 'White (optional)'
    end

    select "25-34", from: 'Age group'
    select "Married", from: 'Relationship'
    select "Hindu", from: 'Religion'
    select "No", from: 'Caring responsibility'
    select "No", from: 'Pregnancy'
    select "No", from: 'diversity_disability'

    click_button "Submit questionnaire"
  end
end
