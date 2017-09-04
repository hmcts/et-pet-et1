require 'rails_helper'

RSpec.describe ClaimantCsvPresenter, type: :presenter do
  let(:claimant_csv_presenter) { described_class.new claim }

  let(:claim) { create :claim }

  describe ".i18n_key" do
    it "returns the i18n_key" do
      expect(described_class.i18n_key).to eq 'additional_claimants_upload'
    end
  end

  describe "#group_claim" do
    context "csv is present" do
      it "returns Yes" do
        expect(claimant_csv_presenter.group_claim).to eq 'Yes'
      end
    end

    context "csv is not present" do
      it "returns No" do
        claim.remove_additional_claimants_csv!

        expect(claimant_csv_presenter.group_claim).to eq 'No'
      end
    end
  end

  describe "#file_name" do
    it "returns the name of the file" do
      expect(claimant_csv_presenter.file_name).to eq "file.csv"
    end
  end

  describe "#number_claimants" do
    it "returns the number of claimant models in the csv" do
      expect(claimant_csv_presenter.number_claimants).to eq 5
    end
  end
end
