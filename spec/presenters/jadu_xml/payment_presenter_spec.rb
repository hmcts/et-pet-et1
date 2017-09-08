require 'rails_helper'

RSpec.describe JaduXml::PaymentPresenter, type: :presenter do
  let(:jadu_xml_payment_presenter) { described_class.new claim }

  let(:claim) { create :claim }

  describe "#fee" do
    it "returns the claim for the fee presenter" do
      expect(jadu_xml_payment_presenter.fee).to eq claim
    end
  end

  describe "#receipt" do
    it "returns the claims payment for the receipt presenter" do
      expect(jadu_xml_payment_presenter.receipt).to eq claim.payment
    end
  end
end
