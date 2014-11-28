require 'rails_helper'

RSpec.describe JaduXml::DocumentId, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:time) { Time.zone.now }

  its(:name)    { is_expected.to eq "ETFeesEntry" }
  its(:type)    { is_expected.to eq "ETFeesEntry" }
  its(:version) { is_expected.to eq 1 }

  describe "#id" do
    it "returns the current time in 'number' format" do
      travel_to time do
        expect(subject.id).to eq time.to_s(:number)
      end
    end
  end

  describe "#time" do
    it "returns the current time in xmlschema format" do
      travel_to time do
        expect(subject.time).to eq time.xmlschema
      end
    end
  end
end
