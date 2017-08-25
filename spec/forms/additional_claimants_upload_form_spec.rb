require 'rails_helper'

RSpec.describe AdditionalClaimantsUploadForm, type: :form do

  let(:additional_claimants_upload_form) { described_class.new(resource) }

  let(:resource) { create :claim, :no_attachments }
  let(:path) { Pathname.new(Rails.root) + 'spec/support/files' }
  let(:file) { File.open(path + 'file.csv') }

  describe "validations" do

    before do
      additional_claimants_upload_form.additional_claimants_csv = file
      additional_claimants_upload_form.assign_attributes(has_additional_claimants: 'true')
      additional_claimants_upload_form.valid?
    end

    describe "attachment additional_claimants_csv" do

      context "a valid csv is attached" do
        it "doesn't have errors" do
          expect(additional_claimants_upload_form.errors).to be_empty
        end

        it "updates the number of valid models found on the resource" do
          expect(resource.additional_claimants_csv_record_count).to eq 5
        end
      end

      context "an invalid csv is attached" do
        let(:file) { File.open(path + 'invalid_file.csv') }

        context 'when its value is not a plain text file' do
          let(:file) { File.open(path + 'phil.jpg') }

          it 'adds an error message to the attribute' do
            expect(additional_claimants_upload_form.csv_errors).to include(I18n.t('errors.messages.csv'))
          end
        end

        describe "#csv_errors" do
          it "returns csv validation errors" do
            expect(additional_claimants_upload_form.csv_errors).not_to be_empty
          end
        end

        describe "#erroneous_line_number" do
          it "returns the line number the error occurred on" do
            expect(additional_claimants_upload_form.erroneous_line_number).to eq "4"
          end
        end
      end
    end

    describe "additional_claimants_csv_record_count" do
      it "gets updated after validation" do
        expect(resource.additional_claimants_csv_record_count).to eq 5
      end
    end
  end

  describe "#has_additional_claimants_csv?" do
    it "returns whether a file is present or not" do
      additional_claimants_upload_form.additional_claimants_csv = file
      expect { additional_claimants_upload_form.save }.
        to change { additional_claimants_upload_form.has_additional_claimants_csv? }.from(false).to(true)
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
