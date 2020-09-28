require 'rails_helper'

feature 'Claim type page' do
  include FormMethods

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'Claim type' do
    before do
      visit claim_claim_type_path
    end

    scenario "I don’t need the words optional against specific types of claim" do
      expect(page).not_to have_text("Unfair dismissal (including constructive dismissal) (optional)")
      expect(page).to have_text("Unfair dismissal (including constructive dismissal)")

      expect(page).not_to have_text("Protective Award (optional)")
      expect(page).to have_text("Protective Award")

      expect(page).not_to have_text("Other type of claim (optional)")
      expect(page).to have_text("Other type of claim")

      expect(page).not_to have_text("Are you reporting suspected wrongdoing at work? (optional)")
      expect(page).to have_text("Are you reporting suspected wrongdoing at work?")
      within(:xpath, ".//fieldset[contains(.,'Whistleblowing claim')]/div[1]") do
        choose 'Yes'
      end

      expect(page).not_to have_text("Do you want us to send a copy of your claim to the relevant person or body that deals with whistleblowing? (optional)")
      expect(page).to have_text("Do you want us to send a copy of your claim to the relevant person or body that deals with whistleblowing?")

      click_button "Save and continue"
      expect(page).to have_text("Claim details")
    end

  end
end
