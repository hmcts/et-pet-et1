require 'rails_helper'

RSpec.describe JaduXml::ReceiptPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) { create :claim }

  around { |example| travel_to(Date.new(2014, 9, 29)) { example.run } }

  describe "delegated methods" do
    it { is_expected.to delegate_method(:created_at).to(:represented) }
  end

  describe "#payment_service_provider" do
    specify { expect(subject.payment_service_provider).to eq "Barclaycard" }
  end

  describe "#date" do
    it "returns the claims payment created at date in xmlschema format" do
      expect(subject.date).to eq claim.payment.created_at.xmlschema
    end
  end
end
