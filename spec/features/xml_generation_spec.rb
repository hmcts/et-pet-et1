require 'rails_helper'

feature 'XML Generation' do
  include FormMethods

  before { complete_and_submit_claim }

  let(:root_path) { Pathname.new(Rails.root) }
  let(:claim_xml) { JaduXml::ClaimPresenter.new(Claim.last).to_xml }
  let(:xsd)       { Nokogiri::XML::Schema(File.read(root_path + 'spec/support/ETFees_v0.19.xsd')) }
  let(:doc)       { Nokogiri::XML(claim_xml) }

  scenario 'produces valid xml with a single claimant' do
    expect(xsd.validate(doc)).to be_empty

    doc.remove_namespaces!
    expect(doc.xpath("//Claimant//Forename").children.map(&:to_s)).
      to match_array %w<Barrington>
  end

  context "with attachments" do
    before do
      Claim.last.tap do |claim|
        claim.additional_claimants_csv = File.open(root_path + 'spec/support/files/file.csv')
        claim.additional_information_rtf = File.open(root_path + 'spec/support/files/file.rtf')
        claim.save
      end
    end

    scenario 'produces valid xml for multiple claimants from an external source' do
      expect(xsd.validate(doc)).to be_empty

      doc.remove_namespaces!

      expect(doc.xpath("//Claimant//Forename").children.map(&:to_s)).
        to match_array %w<Barrington dodge horsey jakub michael shergar>
    end

    scenario 'xml contains filenames & checksums of attachments' do
      expect(xsd.validate(doc)).to be_empty

      doc.remove_namespaces!

      expect(doc.xpath("//Filename").children.map(&:to_s)).
        to match_array %w<file.csv file.rtf et1_barrington_wrigglesworth.pdf>

      expect(doc.xpath("//Checksum").children.map(&:to_s)).
        to match_array %w<ee7d09ca06cab35f40f4a6b6d76704a7 58d5af93e8ee5b89e93eb13b750f8301 65b207906e0f13adc32a439cc7413830>
    end
  end
end
