require 'rails_helper'

RSpec.describe JaduXml::FilePresenter, type: :presenter do
  let(:claim) {
    # access a carrierwave sanitized file..
    Claim.new do |c|
      c.attachment = File.open(Rails.root + 'spec/support/files/file.rtf')
    end
  }
  let(:file) { claim.attachment }

  subject { described_class.new file }

  describe "decorated methods" do
    describe "#filename" do
      it "returns the name of the file" do
        expect(subject.filename).to eq "file.rtf"
      end
    end

    describe "#checksum" do
      it "returns an md5 hexdigest of the file" do
        expect(subject.checksum).to eq "ee7d09ca06cab35f40f4a6b6d76704a7"
      end
    end
  end
end
