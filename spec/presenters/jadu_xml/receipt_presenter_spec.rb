require 'rails_helper'

RSpec.describe JaduXml::ReceiptPresenter, type: :presenter do
  let(:jadu_xml_receipt_presenter) { described_class.new claim }

  let(:claim) { create :claim }

  around { |example| travel_to(Date.new(2014, 9, 29)) { example.run } }

  describe "delegated methods" do
    it { expect(jadu_xml_receipt_presenter).to delegate_method(:created_at).to(:represented) }
  end

  describe "#payment_service_provider" do
    specify { expect(jadu_xml_receipt_presenter.payment_service_provider).to eq "Barclaycard" }
  end

  describe "#date" do
    it "returns the claims payment created at date in xmlschema format" do
      expect(jadu_xml_receipt_presenter.date).to eq claim.payment.created_at.xmlschema
    end
  end
end
