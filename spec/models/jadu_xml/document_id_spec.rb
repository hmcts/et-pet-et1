require 'rails_helper'

RSpec.describe JaduXml::DocumentId, type: :model do
  before(:each) { travel_to Date.new(2014, 9, 29) }

  its(:name)    { is_expected.to eq "ETFeesEntry" }
  its(:type)    { is_expected.to eq "ETFeesEntry" }
  its(:version) { is_expected.to eq 1 }

  describe "#id" do
    it "returns the current time in 'number' format" do
      expect(subject.id).to eq "20140929000000"
    end
  end

  describe "#time" do
    it "returns the current time in xmlschema format" do
      expect(subject.time).to eq "2014-09-29T00:00:00Z"
    end
  end
end
