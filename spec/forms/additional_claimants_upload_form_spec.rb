require 'rails_helper'

RSpec.describe AdditionalClaimantsUploadForm, type: :form do

  let(:additional_claimants_upload_form) { described_class.new(resource) }

  let(:resource) { create :claim, :no_attachments }
  let(:path) { Rails.root.join('spec/support/files').to_s }
  let(:file) { { 'path' => path, 'filename' => 'test.csv', 'content_type' => 'application/csv' } }

  describe "validations" do
    let(:errors) do
      [
        { code: "invalid", attribute: :date_of_birth, row: 3 },
        { code: "invalid", attribute: :post_code, row: 4 }
      ]
    end
    let(:et_api_url) { 'http://api.et.net:4000/api/v2' }

    around do |example|
      ClimateControl.modify ET_API_URL: et_api_url do
        example.run
      end
    end

    before do
      EtTestHelpers.stub_validate_additional_claimants_api(errors:)
      additional_claimants_upload_form.additional_claimants_csv = file
      additional_claimants_upload_form.assign_attributes(has_additional_claimants: 'true')
      additional_claimants_upload_form.valid?
    end

    describe "attachment additional_claimants_csv" do

      context "when a valid csv is attached" do
        let(:errors) { [] }

        it "doesn't have errors" do
          expect(additional_claimants_upload_form.errors).to be_empty
        end

        it "updates the number of valid models found on the resource" do
          expect(resource.additional_claimants_csv_record_count).to eq 10
        end
      end

      context "when an invalid csv is attached" do
        let(:errors) do
          [
            { code: "invalid_columns" }
          ]
        end

        context 'when the api responds with invalid_columns' do

          it 'adds an error message to the attribute' do
            expect(additional_claimants_upload_form.csv_errors).to include('Your CSV file has 1 or more errors')
          end
        end

        describe "#csv_errors" do
          it "returns csv validation errors" do
            expect(additional_claimants_upload_form.csv_errors).not_to be_empty
          end
        end
      end
    end

    describe "additional_claimants_csv_record_count" do
      let(:errors) { [] }

      it "gets updated after validation" do
        expect(resource.additional_claimants_csv_record_count).to eq 10
      end
    end
  end

  describe "#has_additional_claimants_csv?" do
    let(:errors) { [] }

    before do
      EtTestHelpers.stub_validate_additional_claimants_api(errors:)
    end

    it "returns whether a file is present or not" do
      expect { additional_claimants_upload_form.additional_claimants_csv = file }.
        to change(additional_claimants_upload_form, :has_additional_claimants_csv?).from(false).to(true)
    end
  end

  describe "before validation" do
    context "additional claimants option is not selected"

    before do
      resource.additional_claimants_csv = file
      additional_claimants_upload_form.assign_attributes(has_additional_claimants: 'false')
    end

    it "removes stale data" do
      expect(resource).to receive(:remove_additional_claimants_csv!)
      additional_claimants_upload_form.save
    end
  end
end
