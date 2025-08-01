require 'rails_helper'

describe 'Multiple claimants', :js, type: :feature do
  include FormMethods
  include ET1::Test::PageObjectHelpers

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }

  let(:attributes) do
    {
      'First name' => 'Persephone',
      'Last name' => 'Lollington',

      'Day' => '15',
      'Month' => '1',
      'Year' => '1999',

      'Building number or name' => '1',
      'Street' => 'High street',
      'Town/city' => 'Anytown',
      'County' => 'Anyfordshire',
      'Postcode' => 'AT1 4PQ'
    }
  end
  let(:claimant_factory) { build(:ui_secondary_claimant, :default) }

  let(:secondary_attributes) do
    attributes.update 'First name' => 'Pegasus'
  end

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimants' do
    before do
      group_claims_page.load
      group_claims_page.wait_until_displayed
      group_claims_page.fill_in_all(secondary_claimants: [claimant_factory])
    end

    it "filling in a claimant and clicking 'Add more claimants' does not lose the entered details" do
      second_claimant = build(:ui_secondary_claimant, :default)
      expect(page).to have_no_selector '#resource_1'

      group_claims_page.append_secondary_claimants([second_claimant])

      expect(group_claims_page.secondary_claimants).to contain_exactly(claimant_factory, second_claimant)
    end

    it 'adding more than one additional claimant' do
      extra_claimant = build(:ui_secondary_claimant, :default)
      group_claims_page.
        append_secondary_claimants([extra_claimant]).
        save_and_continue
      representatives_details_page.wait_until_displayed
      expect(claim.secondary_claimants.pluck(:last_name)).to contain_exactly(claimant_factory.last_name, extra_claimant.last_name)
    end

    it 'a user can still save & complete later' do
      expect(page).to have_signout_button

      click_link_or_button "Add more claimants"

      expect(page).to have_signout_button
    end

    it "Date of birth form helper text" do
      expect(page).to have_no_selector '#resource_1'
      click_link_or_button "Add more claimants"

      expect(page).to have_css '#resource_1'

      within '#resource_0' do
        expect(page).to have_text('For example, 23 04 1981')
      end

      within '#resource_1' do
        expect(page).to have_text('For example, 23 04 1981')
      end
    end

    context "when additional claimants age has to be valid", :js do
      it "error message if DoB is in future" do
        expect(page).to have_no_selector '#resource_1'

        click_link_or_button "Add more claimants"

        within '#resource_1' do
          select 'Mr', from: 'Title'
          secondary_attributes.each do |field, value|
            fill_in field, with: value
          end

          fill_in 'Day', with: "1"
          fill_in 'Month', with: "1"
          fill_in 'Year', with: 2.years.from_now.year
        end

        click_link_or_button "Save and continue"
        expect(page).to have_text("Age must be between 10 and 100")
      end

      it "error message if age is not between 10-100" do
        expect(page).to have_no_selector '#resource_1'

        click_link_or_button "Add more claimants"

        within '#resource_1' do
          select 'Mr', from: 'Title'
          secondary_attributes.each do |field, value|
            fill_in field, with: value
          end

          fill_in 'Day', with: "1"
          fill_in 'Month', with: "1"
          fill_in 'Year', with: "2023"
        end

        click_link_or_button "Save and continue"
        expect(page).to have_text("Age must be between 10 and 100")
      end

      it "error message if DoB is missing" do
        expect(page).to have_no_selector '#resource_1'

        click_link_or_button "Add more claimants"

        within '#resource_1' do
          select 'Mr', from: 'Title'
          secondary_attributes.each do |field, value|
            fill_in field, with: value
          end

          fill_in 'Day', with: "1"
          fill_in 'Month', with: "1"
          fill_in 'Year', with: "12"
        end

        click_link_or_button "Save and continue"
        within '#resource_0' do
          expect(page).to have_no_text("Year must be 4 digits")
        end
      end
    end
  end

  describe 'destroying claimants' do
    before do
      add_some_additional_claimants
    end

    it 'deleting arbitrary claimants' do
      group_claims_page.load
      group_claims_page.remove_claimant(index: 1)

      expect(page).to have_no_css('#resource_1')

      group_claims_page.save_and_continue
      expect(page).to have_no_content("Group claims")
      expect(claim.secondary_claimants.size).to eq 1
    end
  end

  describe 'indicating there are no additional claimants' do
    it 'when no additional claimants have been previously added' do
      group_claims_page.load
      group_claims_page.no_secondary_claimants
      group_claims_page.save_and_continue

      expect(claim.secondary_claimants).to be_empty
      expect(page).to have_no_current_path claim_additional_claimants_path, ignore_query: true
    end

    it 'when additional claimants have been previously added' do
      add_some_additional_claimants

      group_claims_page.load
      group_claims_page.no_secondary_claimants
      group_claims_page.save_and_continue

      expect(claim.secondary_claimants).to be_empty
      expect(page).to have_no_current_path claim_additional_claimants_path, ignore_query: true
    end
  end

  def add_some_additional_claimants
    second_claimant = build(:ui_secondary_claimant, :default)
    group_claims_page.load
    group_claims_page.fill_in_all(secondary_claimants: [claimant_factory, second_claimant])
    group_claims_page.save_and_continue
    expect(page).to have_no_content('Group claims')
  end
end
