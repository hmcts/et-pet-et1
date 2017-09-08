require 'rails_helper'

RSpec.describe JaduXml::DocumentIdPresenter, type: :presenter do
  around { |example| travel_to Date.new(2014, 9, 29) { example.run } }

  let(:jadu_xml_document_presenter) { described_class.new(Object.new) }

  its(:name)    { is_expected.to eq "ETFeesEntry" }
  its(:type)    { is_expected.to eq "ETFeesEntry" }
  its(:version) { is_expected.to eq 1 }

  describe "#id" do
    it "returns the current time in 'number' format" do
      expect(jadu_xml_document_presenter.id).to eq "20140929000000"
    end
  end

  describe "#time" do
    it "returns the current time in xmlschema format" do
      expect(jadu_xml_document_presenter.time).to eq "2014-09-29T00:00:00Z"
    end
  end
end
