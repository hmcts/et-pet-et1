require 'rails_helper'

RSpec.describe AdditionalClaimantsUploadForm, type: :form do

  subject { described_class.new(resource) }

  let(:resource) { create :claim, :no_attachments }
  let(:path) { Pathname.new(Rails.root) + 'spec/support/files' }
  let(:file) { File.open(path + 'file.csv') }

  describe "validations" do

    before do
      subject.additional_claimants_csv = file
      subject.assign_attributes(has_additional_claimants: 'true')
      subject.valid?
    end

    describe "attachment additional_claimants_csv" do

      context "a valid csv is attached" do
        it "doesn't have errors" do
          expect(subject.errors).to be_empty
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
            expect(subject.csv_errors).to include(I18n.t('errors.messages.csv'))
          end
        end

        describe "#csv_errors" do
          it "returns csv validation errors" do
            expect(subject.csv_errors).not_to be_empty
          end
        end

        describe "#erroneous_line_number" do
          it "returns the line number the error occurred on" do
            expect(subject.erroneous_line_number).to eq "4"
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
      subject.additional_claimants_csv = file
      expect { subject.save }.
        to change { subject.has_additional_claimants_csv? }.from(false).to(true)
    end
  end

  describe "before validation" do
    context "additional claimants option is not selected"

    before do
      resource.additional_claimants_csv = file
      subject.assign_attributes(has_additional_claimants: 'false')
    end

    it "removes stale data" do
      expect(resource).to receive(:remove_additional_claimants_csv!)
      subject.save
    end
  end
end
