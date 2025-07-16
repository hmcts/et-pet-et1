require 'rails_helper'
require 'securerandom'

describe 'Attaching a document', :js, type: :feature do
  include FormMethods
  include Messages
  include EtTestHelpers::RSpec

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }
  let(:file_path) { Rails.root.join('spec/support/files/').to_s }
  let(:invalid_file_path) { "#{file_path}phil.jpg" }

  before do
    return_to_your_claim_page.
      load.
      return_to_your_claim claim_number: claim.reference, memorable_word: 'lollolol'
    claimants_details_page.assert_claim_retrieved_success
  end

  describe 'For claim details RTF upload', :with_stubbed_azure_upload do
    let(:et_api_url) { 'http://api.et.127.0.0.1.nip.io:3100/api/v2' }
    let(:rtf_file_path) { "#{file_path}file.rtf" }
    let(:alternative_rtf_file_path) { "#{file_path}alt_file.rtf" }
    let(:ui_claim_details) { build(:ui_claim_details, :default) }

    around do |example|
      ClimateControl.modify ET_API_URL: et_api_url do
        example.run
      end
    end

    context 'when uploading a valid RTF file' do
      let(:ui_claim_details) { build(:ui_claim_details, :default, rtf_file_path: rtf_file_path) }

      before do
        claim_details_page.
          load.
          fill_in_all(claim_details: ui_claim_details).
          save_and_continue
      end

      it 'Attaching the file' do
        expect(claim.reload.claim_details_rtf['filename']).to eq File.basename(rtf_file_path)
      end

      it 'Deleting the file' do
        claim_details_page.
          load.
          remove_rtf_file.
          save_and_continue

        expect(claim.reload.claim_details_rtf.present?).to be false
      end

      it 'Replacing the file' do
        ui_claim_details.rtf_file_path = alternative_rtf_file_path
        claim_details_page.
          load.
          claim_details_file_question.remove_file
        sleep 2
        claim_details_page.
          fill_in_all(claim_details: ui_claim_details).
          save_and_continue

        expect(claim.reload.claim_details_rtf['filename']).to eq File.basename(alternative_rtf_file_path)
      end
    end
  end

  describe 'For additional claimants', :with_stubbed_azure_upload do
    let(:et_api_url) { 'http://api.et.127.0.0.1.nip.io:3100/api/v2' }
    let(:csv_file_path) { "#{file_path}file.csv" }
    let(:alternative_csv_file_path) { "#{file_path}alt_file.csv" }

    around do |example|
      ClimateControl.modify ET_API_URL: et_api_url do
        example.run
      end
    end

    before { EtTestHelpers.stub_validate_additional_claimants_api }

    context 'with a valid CSV file' do
      before do
        group_claims_upload_page.load
        group_claims_upload_page.upload_secondary_claimants_csv(csv_file_path).save_and_continue
      end

      it 'Attaching the file' do
        expect(claim.reload.additional_claimants_csv).to include filename: File.basename(csv_file_path)
      end

      it 'Deleting the file' do
        visit '/apply/additional-claimants-upload'
        sleep 2
        group_claims_upload_page.remove_csv_file
        click_link_or_button 'Save and continue'
        sleep 2

        expect(claim.reload.additional_claimants_csv.present?).to be false
      end

      it 'Replacing the file' do
        group_claims_upload_page.load
        group_claims_upload_page.upload_file_question.remove_file
        group_claims_upload_page.upload_secondary_claimants_csv(alternative_csv_file_path).save_and_continue

        expect(claim.reload.additional_claimants_csv).to include filename: File.basename(alternative_csv_file_path)
      end
    end

    context 'with an invalid file' do
      before do
        errors = [
          { code: "invalid", attribute: :date_of_birth, row: 4 },
          { code: "invalid", attribute: :post_code, row: 4 }
        ]
        EtTestHelpers.stub_validate_additional_claimants_api(errors: errors)
      end

      let(:invalid_csv_path) { "#{file_path}invalid_file.csv" }

      it 'Uploading a CSV file with errors' do
        group_claims_upload_page.load
        group_claims_upload_page.upload_secondary_claimants_csv(invalid_csv_path).save_and_continue
        page.find('span', text: 'Error details').click
        expect(page).to have_text('Row 4 Enter a valid UK postcode. If you live abroad, enter SW55 9QT')
        expect(page).to have_text('Row 4 Enter a valid date of birth in the correct format (DD/MM/YYYY)')
        expect(claim.additional_claimants_csv).not_to be_present
      end
    end
  end
end
