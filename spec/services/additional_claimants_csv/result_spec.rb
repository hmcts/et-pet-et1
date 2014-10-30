require 'rails_helper'

RSpec.describe AdditionalClaimantsCsv::Result, type: :service do

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
    before(:each) { subject.fail(["some errors", "some more errors"]) }
    its(:success)     { is_expected.to be false }
    its(:errors)      { is_expected.not_to be_empty }
  end

  describe "#error_line" do
    it "includes the header row in the value returned" do
      subject.line_count = 1
      expect(subject.error_line).to eq 2
    end
  end
end
