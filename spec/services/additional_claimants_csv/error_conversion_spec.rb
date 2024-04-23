require 'rails_helper'

RSpec.describe AdditionalClaimantsCsv::ErrorConversion, type: :service do

  let(:header) {
    ["Title", "First name", "Last name", "Date of birth", "Building number or name",
     "Street", "Town/city", "County", "Postcode"]
  }

  let(:model_errors) { ActiveModel::Errors.new(Object.new) }

  describe "#convert" do

    before do
      model_errors.add(:title, "such invalid title")
      model_errors.add(:address_street, "so very long text")
    end

    context "with errors" do
      describe "returns an array of error messages" do
        let(:errors) { described_class.new(header, model_errors).convert }

        it { expect(errors.size).to eq 2 }
        it { expect(errors.first).to eq "Title - such invalid title" }
        it { expect(errors.second).to eq "Street - so very long text" }
      end
    end
  end
end
