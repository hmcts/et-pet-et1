require 'rails_helper'

feature 'Multiple claimants CSV', js: true do
  include FormMethods

  let(:et_api_url) { 'http://api.et.127.0.0.1.nip.io:3100/api/v2' }
  around do |example|
    ClimateControl.modify ET_API_URL: et_api_url do
      example.run
    end
  end
  let(:claim) { Claim.create user: User.new(password: 'lollolol') }
  let(:file_path) do
    csv_string = CSV.generate do |csv|
      csv << ["Title", "First name", "Last name", "Date of birth", "Building number or name", "Street", "Town/city", "County", "Postcode"]
      csv << csv_line
    end
    begin
      file = Tempfile.new(['test', '.csv'])
      file.write(csv_string)
      file.path
    ensure
      file&.close
    end
  end
  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimants', with_stubbed_azure_upload: true do
    before { EtTestHelpers.stub_validate_additional_claimants_api }
    before do
      group_claims_upload_page.load
    end

    context "group claimants age has to be 16 or over" do
      before do
        errors = [
          { code: "too_young", attribute: :date_of_birth, row: 2 },
          { code: "invalid", attribute: :date_of_birth, row: 3 },
          { code: "invalid", attribute: :post_code, row: 4 }
        ]
        EtTestHelpers.stub_validate_additional_claimants_api(errors: errors)
      end

      let(:csv_line) { ["Mr", "Tom", "Test", "01/01/2016", "1", "Test", "London", "Great London", "N103QS"] }

      scenario "if claimant is too young" do
        group_claims_upload_page.upload_secondary_claimants_csv(file_path).save_and_continue
        group_claims_upload_page.expand_csv_file_errors
        expect(page).to have_text("Row 2 Claimant must be 16 years of age or over")
      end
    end
  end
end
