require 'rails_helper'

feature 'Diversity' do

  before do
    visit diversity_path
  end

  scenario "I should be able to fill the diversity form" do
    expect(page).to have_text "Diversity monitoring questionnaire"
    expect(page).to have_text "This is optional and won't affect your claim."
    expect(page).to have_text "Your answers will be anonymous. "

    click_link "Begin this form"
  end
end
