require 'rails_helper'

feature 'Multiple claimants CSV' do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimants' do
    before do
      visit claim_additional_claimants_upload_path
      choose 'Yes'
    end

    context "group claimants age has to be 16 or over" do
      scenario "display age related error message" do
        upload_group_claim_file
        click_button "Save and continue"

        expect(page).not_to have_text("An error has been found on line 2 of the uploaded file.")
        expect(page).to have_text("An error has been found on line 3 of the uploaded file.")
        expect(page).to have_text("Date of birth - Claimant must be 16 years of age or over")
        expect(page).not_to have_text("An error has been found on line 4 of the uploaded file.")
      end

    end
  end

  def upload_group_claim_file
    # DoB in file is set to 2016 bcs I don't think this test will exist in 15 years and
    # to make it dynamic would be more work.
    file_path = File.absolute_path('./spec/support/files/group-claim.csv')
    attach_file('additional_claimants_upload_additional_claimants_csv', file_path)
  end
end
