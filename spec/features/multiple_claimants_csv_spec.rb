require 'rails_helper'

describe 'Multiple claimants CSV', js: true do
  include FormMethods

  let(:et_api_url) { 'http://api.et.127.0.0.1.nip.io:3100/api/v2' }
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

  around do |example|
    ClimateControl.modify ET_API_URL: et_api_url do
      example.run
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

    context "group claimants age has to be valid" do
      before do
        errors = [
          { code: "invalid", attribute: :date_of_birth, row: 3 },
          { code: "invalid", attribute: :post_code, row: 4 }
        ]
        EtTestHelpers.stub_validate_additional_claimants_api(errors: errors)
      end
    end
  end
end
