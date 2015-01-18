require 'rails_helper'

feature 'Your fee page' do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  before do
    claim.create_primary_claimant
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  context 'single claimant' do
    scenario 'indicating remission' do
      visit claim_your_fee_path

      expect(page).to_not have_field("How many in your group want to apply for fee remission?")

      choose 'Yes'

      click_button 'Save and continue'

      expect(claim.reload.remission_claimant_count).to eq 1
    end

    scenario 'indicating no remission' do
      visit claim_your_fee_path

      expect(page).to_not have_field("How many in your group want to apply for fee remission?")

      choose 'No'

      click_button 'Save and continue'

      expect(claim.reload.remission_claimant_count).to eq 0
    end
  end

  context 'multiple claimants' do
    {
      "from DB"  => ->(c) { c.secondary_claimants.create },
      "from CSV" => ->(c) { c.update additional_claimants_csv_record_count: 1 }
    }.each do |description, setup|
      context description do
        before { setup.call(claim) }

        scenario 'indicating remission' do
          visit claim_your_fee_path

          %w<Yes No>.each { |opt| expect(page).to_not have_button opt }

          fill_in "How many in your group want to apply for fee remission?", with: 2

          click_button 'Save and continue'

          expect(claim.reload.remission_claimant_count).to eq 2
        end

        scenario 'trying to set remission claimants > number of claimants' do
          visit claim_your_fee_path

          %w<Yes No>.each { |opt| expect(page).to_not have_button opt }

          fill_in "How many in your group want to apply for fee remission?", with: 200

          click_button 'Save and continue'

          expect(page.current_path).to eq claim_your_fee_path
          expect(page).to have_text "Please provide information in the highlighed fields."
          expect(claim.reload.remission_claimant_count).to eq 0
        end
      end
    end
  end
end
