require 'rails_helper'

RSpec.describe JaduXml::AddressPresenter, type: :presenter do
  let(:address) { Address.new { |a| a.building = "1234 Lol Mansions" } }
  subject { described_class.new address }

  describe "decorated methods" do
    describe "#number" do
      it "returns the number if present" do
        expect(subject.number).to eq "1234"
      end

      context "number is not present" do
        before { address.building = "Lol Mansions" }
        it "returns and empty string if no number is present" do
          expect(subject.number).to eq ""
        end
      end
    end

    describe "#name" do
      it "returns the name if present" do
        expect(subject.name).to eq "Lol Mansions"
      end

      context "name is not present" do
        before { address.building = "100" }
        it "returns and empty string if no name is present" do
          expect(subject.name).to eq ""
        end
      end
    end
  end
end
