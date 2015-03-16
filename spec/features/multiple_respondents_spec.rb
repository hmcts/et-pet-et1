require 'rails_helper'

feature 'Multiple respondents' do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  before do
    stub_request(:post, "#{ENV.fetch('JADU_API')}fgr-et-office").
      with(body: "postcode=SW1A%201AA", headers: { 'Accept' => 'application/json' })

    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  let(:attributes) do
    {
      'Name'                    => 'Butch McTaggert',
      'Acas number'             => 'XX123456/12/12',
      'Building number or name' => '3',
      'Street'                  => 'Lol Lane',
      'Town/city'               => 'Jokesville',
      'County'                  => 'Anyfordshire',
      'Postcode'                => 'SW1A 1AA'
    }
  end

  let(:secondary_attributes) do
    attributes.
      update('Name' => 'Pablo Noncer').
      except('Acas number')
  end

  describe 'adding respondents' do
    before do
      visit claim_additional_respondents_path

      choose 'Yes'

      attributes.each do |field, value|
        fill_in field, with: value
      end
    end

    scenario "filling in a respondent and clicking 'Add another respondent' does not lose the entered details" do
      expect(page).not_to have_selector '#resource_1'

      click_button "Add another respondent"

      expect(page).to have_selector '#resource_1'

      within '#resource_0' do

        attributes.each do |field, value|
          expect(page).to have_field(field, with: value)
        end
      end
    end

    scenario 'adding more than one additional respondent' do
      click_button "Add another respondent"

      within '#resource_1' do
        secondary_attributes.each do |field, value|
          fill_in field, with: value
        end

        check "I don’t have an Acas number"

        choose "My claim is against the Security Service, Secret Intelligence Service or GCHQ"
      end

      click_button 'Save and continue'

      expect(claim.secondary_respondents.pluck(:name)).
        to match_array ['Butch McTaggert', 'Pablo Noncer']
    end
  end

  describe 'destroying respondents' do
    before { add_some_additional_respondents }

    scenario 'deleting arbitrary respondents' do
      visit claim_additional_respondents_path

      within '#resource_1' do
        check 'Remove this respondent'
      end

      click_button 'Save and continue'

      expect(claim.secondary_respondents.pluck(:name)).to eq ['Butch McTaggert']
    end
  end

  describe 'indicating there are no additional respondents' do
    scenario 'when no additional respondents have been previously added' do
      visit claim_additional_respondents_path

      choose "No"

      click_button 'Save and continue'

      expect(claim.secondary_respondents).to be_empty
      expect(page.current_path).not_to eq claim_additional_respondents_path
    end

    scenario 'when additional respondents have been previously added' do
      add_some_additional_respondents

      visit claim_additional_respondents_path

      choose "No"

      click_button 'Save and continue'

      expect(claim.secondary_respondents).to be_empty
      expect(page.current_path).not_to eq claim_additional_respondents_path
    end
  end

  def add_some_additional_respondents
    visit claim_additional_respondents_path

    choose 'Yes'

    attributes.each do |field, value|
      fill_in field, with: value
    end

    click_button 'Add another respondent'

    within '#resource_1' do
      secondary_attributes.each do |field, value|
        fill_in field, with: value
      end

      check "I don’t have an Acas number"

      choose "My claim is against the Security Service, Secret Intelligence Service or GCHQ"
    end

    click_button 'Save and continue'
  end
end
