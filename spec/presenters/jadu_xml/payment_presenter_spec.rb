require 'rails_helper'

RSpec.describe JaduXml::PaymentPresenter, type: :presenter do
  let(:claim) { create :claim }

  subject { described_class.new claim }

  describe "#fee" do
    it "returns the claim for the fee presenter" do
      expect(subject.fee).to eq claim
    end
  end

  describe "#receipt" do
    it "returns the claims payment for the receipt presenter" do
      expect(subject.receipt).to eq claim.payment
    end
  end
end
