require 'rails_helper'

feature 'Multiple claimants', js: true do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  let(:attributes) do
    {
      'First name' => 'Persephone',
      'Last name'  => 'Lollington',

      'Day'   => '15',
      'Month' => '1',
      'Year'  => '1985',

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
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimants' do
    before do
      visit claim_additional_claimants_path

      choose 'Yes'
      select 'Mrs', from: 'Title'

      attributes.each do |field, value|
        fill_in field, with: value
      end
    end

    scenario "filling in a claimant and clicking 'Add more claimants' does not lose the entered details" do
      expect(page).not_to have_selector '#resource_1'

      click_button "Add more claimants"

      expect(page).to have_selector '#resource_1'

      within '#resource_0' do
        expect(page).to have_select('Title', selected: 'Mrs')

        attributes.each do |field, value|
          expect(page).to have_field(field, with: value)
        end
      end
    end

    scenario 'adding more than one additional claimant' do
      click_button "Add more claimants"

      within '#resource_1' do
        select 'Mr', from: 'Title'

        secondary_attributes.each do |field, value|
          fill_in field, with: value
        end
      end

      click_button 'Save and continue'
      expect(page).not_to have_content("Group Claims")
      expect(claim.secondary_claimants.pluck(:first_name)).to match_array ['Persephone', 'Pegasus']
    end

    scenario 'a user can still save & complete later' do
      expect(page).to have_signout_button

      click_button "Add more claimants"

      expect(page).to have_signout_button
    end

    scenario "Date of birth form helper text" do
      expect(page).not_to have_selector '#resource_1'
      click_button "Add more claimants"

      expect(page).to have_selector '#resource_1'

      within '#resource_0' do
        expect(page).to have_text('For example, 23 04 1981')
      end

      within '#resource_1' do
        expect(page).to have_text('For example, 23 04 1981')
      end
    end

    context "additional claimants age has to be 16 or over", js: false do
      scenario "display age related error message" do
        expect(page).not_to have_selector '#resource_1'

        click_button "Add more claimants"
        within '#resource_1' do
          sixteen_years_ago = (Time.now - 14.years)
          fill_in 'Day', with: sixteen_years_ago.day.to_s
          fill_in 'Month', with: sixteen_years_ago.month.to_s
          fill_in 'Year', with: sixteen_years_ago.year.to_s
        end

        click_button "Save and continue"
        expect(page).to have_text("Provide information in the highlighted fields")

        within '#resource_1' do
          expect(page).to have_text("Claimant must be 16 years of age or over")
        end

        # This one is older then 16
        within '#resource_0' do
          expect(page).not_to have_text("Claimant must be 16 years of age or over")
        end
      end

      scenario "error message if DoB is missing" do
        expect(page).not_to have_selector '#resource_1'

        click_button "Add more claimants"

        within '#resource_1' do
          select 'Mr', from: 'Title'
          secondary_attributes.each do |field, value|
            fill_in field, with: value
          end

          fill_in 'Day', with: ""
          fill_in 'Month', with: ""
          fill_in 'Year', with: ""
        end

        click_button "Save and continue"
        within '#resource_0' do
          expect(page).not_to have_text("Claimant must be 16 years of age or over")
        end
      end
    end

    scenario "display DoB format error message" do
      expect(page).not_to have_selector '#resource_1'

      click_button "Add more claimants"
      expect(page).to have_selector '#resource_1'

      within '#resource_1' do
        fill_in 'Day', with: '1'
        fill_in 'Month', with: '1'
        fill_in 'Year', with: '99'
      end

      click_button "Save and continue"
      expect(page).to have_text("Provide information in the highlighted fields")

      within '#resource_1' do
        expect(page).to have_text("Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)")
        expect(page).not_to have_text("Claimant must be 16 years of age or over")
      end

      within '#resource_0' do
        expect(page).not_to have_text("Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)")
        expect(page).not_to have_text("Claimant must be 16 years of age or over")
      end
    end
  end

  describe 'destroying claimants' do
    before { add_some_additional_claimants }

    scenario 'deleting arbitrary claimants' do
      visit claim_additional_claimants_path

      within '#resource_1' do
        click_on 'Remove this claimant'
      end

      click_button 'Save and continue'
      expect(claim.secondary_claimants.size).to eq 1
    end
  end

  describe 'indicating there are no additional claimants' do
    scenario 'when no additional claimants have been previously added' do
      visit claim_additional_claimants_path

      choose "No"

      click_button 'Save and continue'

      expect(claim.secondary_claimants).to be_empty
      expect(page.current_path).not_to eq claim_additional_claimants_path
    end

    scenario 'when additional claimants have been previously added' do
      add_some_additional_claimants

      visit claim_additional_claimants_path

      choose "No"

      click_button 'Save and continue'

      expect(claim.secondary_claimants).to be_empty
      expect(page.current_path).not_to eq claim_additional_claimants_path
    end
  end

  def add_some_additional_claimants
    visit claim_additional_claimants_path

    choose 'Yes'

    select 'Mrs', from: 'Title'

    attributes.each do |field, value|
      fill_in field, with: value
    end

    click_button 'Add more claimants'

    within '#resource_1' do
      select 'Mr', from: 'Title'

      secondary_attributes.each do |field, value|
        fill_in field, with: value
      end
    end

    click_button 'Save and continue'
  end
end
