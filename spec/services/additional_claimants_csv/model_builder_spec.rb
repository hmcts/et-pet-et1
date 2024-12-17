require 'rails_helper'

RSpec.describe AdditionalClaimantsCsv::ModelBuilder, type: :service do

  let(:additional_claimants_csv_builder) { described_class.new }
  let(:row) { ['Mr', 'Timothy', 'Crotchet', "18/09/1999", '69', 'SomeStreet', 'Motown', 'County', 'SE17NX'] }
  let(:model_class) { AdditionalClaimantsForm::AdditionalClaimant }
  let(:expected_attributes) {
    {
      title: "Mr",
      first_name: "Timothy",
      last_name: "Crotchet",
      date_of_birth: Date.parse("18/09/1999"),
      address_building: "69",
      address_street: "SomeStreet",
      address_locality: "Motown",
      address_county: "County",
      address_post_code: "SE17NX"
    }.stringify_keys
  }

  describe "attributes constant" do
    it "is defined with a list of symbols" do
      expect(described_class::ATTRIBUTES).to eq [:title, :first_name, :last_name, :date_of_birth, :address_building, :address_street, :address_locality, :address_county, :address_post_code]
    end
  end

  describe "#build" do
    it "returns an additional claimant model" do
      expect(additional_claimants_csv_builder.build_form_claimant(row)).to be_a model_class
    end

    it "sets attributes on the returned model" do
      model = additional_claimants_csv_builder.build_form_claimant(row)
      model_attributes = model.attributes.slice(*expected_attributes.keys)
      expect(model_attributes).to eq expected_attributes
    end

    it "doesn't create multiple form objects" do
      expect(model_class).to receive(:new).and_call_original.once
      2.times { additional_claimants_csv_builder.build_form_claimant(row) }
    end
  end
end
