require 'rails_helper'

feature 'Claimant page' do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  let(:attributes) do
    {
      'First name' => 'Persephone',
      'Last name'  => 'Lollington',
      'Building number or name' => '1',
      'Street'    => 'High street',
      'Town/city' => 'Anytown',
      'County'    => 'Anyfordshire',
      'Postcode'  => 'AT1 4PQ'
    }
  end

  let(:secondary_attributes) do
    attributes.update 'First name' => 'Pegasus'
  end

  before do
    visit new_claim_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimant that is 16 or more years older' do
    before do
      visit claim_claimant_url

      select 'Mrs', from: 'Title'

      attributes.each do |field, value|
        fill_in field, with: value
      end
    end

    it "displays DOB validation above dob field" do
      year = (Time.current - 15.years).year.to_s
      fill_in 'Day', with: '1'
      fill_in 'Month', with: '1'
      fill_in 'Year', with: year

      click_button "Save and continue"
      expect(page).to have_text("Provide information in the highlighted fields")

      within(:xpath, './/fieldset/div[contains(@class,"claimant_date_of_birth")]') do
        expect(page).to have_text("Claimant must be 16 years of age or over")
      end
    end

    it "displays no validation if older then 16" do
      date_ago = (Time.current - 16.years - 12.hours)
      fill_in 'Day', with: date_ago.day.to_s
      fill_in 'Month', with: date_ago.month.to_s
      fill_in 'Year', with: date_ago.year.to_s

      click_button "Save and continue"
      expect(page).to have_text("Provide information in the highlighted fields")

      within(:xpath, './/fieldset/div[contains(@class,"claimant_date_of_birth")]') do
        expect(page).not_to have_text("Claimant must be 16 years of age or over")
      end
    end

    it "displays validation if no DOB is present" do
      click_button "Save and continue"
      expect(page).to have_text("Provide information in the highlighted fields")
      expect(page).to have_text("Claimant must be 16 years of age or over")
    end

    it "displays validation of DOB is 2 digits" do
      fill_in 'Day', with: '1'
      fill_in 'Month', with: '1'
      fill_in 'Year', with: '12'

      click_button "Save and continue"
      expect(page).to have_text("Provide information in the highlighted fields")

      within(:xpath, './/fieldset/div[contains(@class,"claimant_date_of_birth")]') do
        expect(page).to have_text("Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)")
      end
    end

    it "displays validation if no allow video attendance is present" do
      click_button "Save and continue"
      expect(page).to have_text("Please say whether you would be able to attend a hearing by video")
    end
  end
end
