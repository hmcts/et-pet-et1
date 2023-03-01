require 'rails_helper'

RSpec.describe AdditionalClaimantsCsv::Result, type: :service do

  let(:additional_claimants_csv_result) { described_class.new }

  describe "new instance" do
    its(:success)     { is_expected.to be true }
    its(:line_count)  { is_expected.to be_zero }
    its(:errors)      { is_expected.to be_empty }
    it { is_expected.to respond_to :csv_header }
    it { is_expected.to respond_to :csv_header= }
    it { is_expected.to respond_to :line_count }
    it { is_expected.to respond_to :line_count= }
  end

  describe "#fail" do
    before { additional_claimants_csv_result.fail(["some errors", "some more errors"]) }

    it { expect(additional_claimants_csv_result.success).to be false }
    it { expect(additional_claimants_csv_result.errors).not_to be_empty }
  end

  describe "#error_line" do
    it "includes the header row in the value returned" do
      additional_claimants_csv_result.line_count = 1
      expect(additional_claimants_csv_result.error_line).to eq 2
    end
  end
end
