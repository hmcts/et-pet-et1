require 'rails_helper'

RSpec.describe JaduXml::FeePresenter, type: :presenter do
  let(:jadu_xml_fee_presenter) { described_class.new claim }

  let(:claim) { create :claim }

  around { |example| travel_to(Date.new(2014, 9, 29)) { example.run } }

  describe "delegated methods" do
    it { expect(jadu_xml_fee_presenter).to delegate_method(:fee_calculation).to(:represented) }
    it { expect(jadu_xml_fee_presenter).to delegate_method(:fee_group_reference).to(:represented) }
    it { expect(jadu_xml_fee_presenter).to delegate_method(:submitted_at).to(:represented) }
    it { expect(jadu_xml_fee_presenter).to delegate_method(:application_fee).to(:fee_calculation) }
  end

  describe "#amount" do
    it "returns application fee after remission" do
      allow(jadu_xml_fee_presenter).to receive(:application_fee).and_return 1
      expect(jadu_xml_fee_presenter.amount).to eq 0
    end
  end

  describe "#date" do
    it "returns the claims submitted at date in xmlschema format" do
      expect(jadu_xml_fee_presenter.date).to eq claim.submitted_at.xmlschema
    end
  end
end
