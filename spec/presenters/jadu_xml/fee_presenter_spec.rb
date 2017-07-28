require 'rails_helper'

RSpec.describe JaduXml::FeePresenter, type: :presenter do
  let(:claim) { create :claim }

  subject { described_class.new claim }

  around { |example| travel_to(Date.new 2014, 9, 29) { example.run } }

  describe "delegated methods" do
    it { is_expected.to delegate_method(:fee_calculation).to(:represented) }
    it { is_expected.to delegate_method(:fee_group_reference).to(:represented) }
    it { is_expected.to delegate_method(:submitted_at).to(:represented) }
    it { is_expected.to delegate_method(:application_fee).to(:fee_calculation) }
  end

  describe "#amount" do
    it "returns application fee after remission" do
      allow(subject).to receive(:application_fee).and_return 1
      expect(subject.amount).to eq 0
    end
  end

  describe "#date" do
    it "returns the claims submitted at date in xmlschema format" do
      expect(subject.date).to eq claim.submitted_at.xmlschema
    end
  end
end
