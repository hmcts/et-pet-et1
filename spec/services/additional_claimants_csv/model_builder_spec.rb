require 'rails_helper'

RSpec.describe AdditionalClaimantsCsv::ModelBuilder, type: :service do

  let(:row) { ['Mr', 'Timothy', 'Crotchet', '18/09/1937', '69', 'SomeStreet', 'Motown', 'County', 'SE17NX'] }
  let(:model_class) { AdditionalClaimantsForm::AdditionalClaimant }
  let(:expected_attributes) {
    {
      title: "mr",
      first_name: "timothy",
      last_name: "crotchet",
      date_of_birth: Date.parse("18/09/1937"),
      address_building: "69",
      address_street: "somestreet",
      address_locality: "motown",
      address_county: "county",
      address_post_code: "se17nx"
    }
  }

  describe "attributes constant" do
    it "is defined with a list of symbols" do
      expect(described_class::ATTRIBUTES).to eq [:title, :first_name, :last_name, :date_of_birth, :address_building, :address_street, :address_locality, :address_county, :address_post_code]
    end
  end

  describe "#build" do
    it "returns an additional claimant model" do
      expect(subject.build_form_claimant(row)).to be_kind_of model_class
    end

    it "sets attributes on the returned model" do
      model = subject.build_form_claimant(row)
      model_attributes = model.attributes.slice(*expected_attributes.keys)
      expect(model_attributes).to eq expected_attributes
    end

    it "doesn't create multiple form objects" do
      expect(model_class).to receive(:new).and_call_original.once
      2.times { subject.build_form_claimant(row) }
    end
  end
end
