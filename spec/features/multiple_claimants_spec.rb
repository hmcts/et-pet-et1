require 'rails_helper'

feature 'Multiple claimants' do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  before do
    visit returning_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

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

      expect(claim.secondary_claimants.pluck(:first_name)).to eq %w<Persephone Pegasus>
    end
  end

  describe 'destroying claimants' do
    before { add_some_additional_claimants }

    scenario 'deleting arbitrary claimants' do
      visit claim_additional_claimants_path

      within '#resource_1' do
        check 'Remove this claimant'
      end

      click_button 'Save and continue'

      expect(claim.secondary_claimants.pluck(:first_name)).to eq %w<Persephone>
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
