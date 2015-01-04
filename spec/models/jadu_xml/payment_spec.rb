require 'rails_helper'

RSpec.describe JaduXml::Payment, type: :model do
  let(:time)  { Time.zone.now }
  let(:claim) { Claim.new { |c| c.submitted_at = time } }

  subject { described_class.new claim }

  describe "delegated methods" do
    it { is_expected.to delegate_method(:fee_calculation).to(:claim) }
    it { is_expected.to delegate_method(:fee_group_reference).to(:claim) }
    it { is_expected.to delegate_method(:submitted_at).to(:claim) }
    it { is_expected.to delegate_method(:application_fee_after_remission).to(:fee_calculation) }
  end

  its(:fee) { is_expected.to eq subject }

  describe "#amount" do
    it "returns application fee after remission" do
      allow(subject).to receive(:application_fee_after_remission).and_return 1
      expect(subject.amount).to eq 1
    end
  end

  describe "#date" do
    it "returns the claims submitted at date in xmlschema format" do
      expect(subject.date).to eq time.xmlschema
    end
  end
end
