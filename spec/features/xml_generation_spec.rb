require 'rails_helper'

feature 'XML Generation' do
  include FormMethods

  let(:claim)     { create :claim }
  let(:claim_xml) { JaduXml::ClaimPresenter.new(claim).to_xml }
  let(:xsd)       { Nokogiri::XML::Schema(File.read(Rails.root + 'spec/support/ETFees_v0.19.xsd')) }
  let(:doc)       { Nokogiri::XML(claim_xml) }

  context "claim with a single claimant" do
    let(:claim) { create :claim, :without_additional_claimants_csv }

    scenario 'produces valid xml with a single claimant' do
      expect(xsd.validate(doc)).to be_empty

      doc.remove_namespaces!
      expect(doc.xpath("//Claimant//Forename").children.map(&:to_s)).
        to match_array %w<Barrington>
      expect(doc.xpath("//Representatives").children).not_to be_empty
    end
  end

  context "a claim with no representative" do
    let(:claim) { create :claim, :without_representative }

    scenario 'produces valid xml' do
      expect(xsd.validate(doc)).to be_empty

      doc.remove_namespaces!
      expect(doc.xpath("//Representatives").children).to be_empty
    end
  end

  context "claim with additonal claimants from an external source" do
    scenario 'produces valid xml' do
      expect(xsd.validate(doc)).to be_empty

      doc.remove_namespaces!

      expect(doc.xpath("//Claimant//Forename").children.map(&:to_s)).
        to match_array %w<Barrington dodge horsey jakub michael shergar>
    end
  end

  context "claim with a pdf, csv & rtf attachments" do
    let(:claim) { create :claim, :with_pdf }

    scenario 'xml contains filenames & checksums of attachments' do
      expect(xsd.validate(doc)).to be_empty

      doc.remove_namespaces!

      expect(doc.xpath("//Filename").children.map(&:to_s)).
        to match_array %w<file.csv file.rtf et1_barrington_wrigglesworth.pdf>

      expect(doc.xpath("//Checksum").children.map(&:to_s)).
        to match_array %w<ee7d09ca06cab35f40f4a6b6d76704a7 58d5af93e8ee5b89e93eb13b750f8301 42f1bc8b7f9934a33fd47128a59269e9>
    end
  end
end
