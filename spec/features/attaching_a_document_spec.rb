require 'rails_helper'

feature 'Attaching a document' do
  include FormMethods
  include Messages

  let(:claim) { Claim.create password: 'lollolol' }
  let(:file_path) { Rails.root + 'spec/support/files/' }
  let(:invalid_file_path) { file_path + './phil.jpg' }

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'For claim details RTF upload' do
    let(:rtf_file_path) { file_path + './file.rtf' }
    let(:alternative_rtf_file_path) { file_path + './alt_file.rtf' }

    context 'Uploading a valid RTF file' do
      before :each do
        visit '/apply/claim-details'
        attach_file "claim_details_claim_details_rtf", rtf_file_path
        fill_in_claim_details
      end

      scenario 'Attaching the file' do
        expect(claim.reload.claim_details_rtf_file.read).to eq File.read(rtf_file_path)
      end

      scenario 'Deleting the file' do
        visit '/apply/claim-details'
        check "claim_details_remove_claim_details_rtf"
        click_button 'Save and continue'

        expect(claim.reload.claim_details_rtf.present?).to be false
      end

      scenario 'Replacing the file' do
        visit '/apply/claim-details'
        attach_file "claim_details_claim_details_rtf", alternative_rtf_file_path
        click_button 'Save and continue'

        expect(claim.reload.claim_details_rtf_file.read).to eq File.read(alternative_rtf_file_path)
      end
    end

    scenario 'Uploading a non text file' do
      visit '/apply/claim-details'
      attach_file "claim_details_claim_details_rtf", invalid_file_path
      click_button 'Save and continue'

      expect(page).to have_text('is not an RTF')
      expect(claim.claim_details_rtf).not_to be_present
      expect(page.find("details")).to be_visible
    end
  end

  describe 'For additional claimants' do
    let(:csv_file_path) { file_path + './file.csv' }
    let(:alternative_csv_file_path) { file_path + './alt_file.csv' }

    context 'A valid CSV file' do
      before :each do
        visit '/apply/additional-claimants-upload'
        choose "Yes"
        attach_file "additional_claimants_upload_additional_claimants_csv", csv_file_path
        click_button 'Save and continue'
      end

      scenario 'Attaching the file' do
        expect(claim.reload.additional_claimants_csv_file.read).to eq File.read(csv_file_path)
      end

      scenario 'Deleting the file' do
        visit '/apply/additional-claimants-upload'
        check "additional_claimants_upload_remove_additional_claimants_csv"
        click_button 'Save and continue'

        expect(claim.reload.additional_claimants_csv_file.present?).to be false
      end

      scenario 'Replacing the file' do
        visit '/apply/additional-claimants-upload'
        attach_file "additional_claimants_upload_additional_claimants_csv", alternative_csv_file_path
        click_button 'Save and continue'

        expect(claim.reload.additional_claimants_csv_file.read).to eq File.read(alternative_csv_file_path)
      end
    end

    context 'An invalid file' do
      let(:invalid_csv_path) { file_path + './invalid_file.csv' }

      scenario 'Uploading a CSV file with errors' do
        visit '/apply/additional-claimants-upload'
        choose "Yes"
        attach_file "additional_claimants_upload_additional_claimants_csv", invalid_csv_path

        click_button 'Save and continue'

        expect(page).to have_text('An error has been found on line 4 of the uploaded file.')
        expect(page).to have_text('Postcode - Enter a valid UK postcode. If you live abroad, enter SW55 9QT')
        expect(page).to have_text('Date of birth - is invalid')
        expect(claim.additional_claimants_csv).not_to be_present
      end

      scenario 'Uploading a file not of a CSV type' do
        visit '/apply/additional-claimants-upload'
        choose "Yes"
        attach_file "additional_claimants_upload_additional_claimants_csv", invalid_file_path
        click_button 'Save and continue'

        expect(page).to have_text('is not a CSV')
        expect(claim.additional_claimants_csv).not_to be_present
      end
    end
  end
end
