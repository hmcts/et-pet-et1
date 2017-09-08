require 'rails_helper'

RSpec.describe JaduXml::FilePresenter, type: :presenter do
  let(:jadu_xml_file_presenter) { described_class.new claim.claim_details_rtf }

  let(:claim) { create :claim }

  describe "decorated methods" do
    describe "#filename" do
      it "returns the name of the file" do
        expect(jadu_xml_file_presenter.filename).to eq "file.rtf"
      end

      context 'when the filename is hyphenated' do
        let(:claim) { create :claim, :non_sanitized_attachment_filenames }

        it 'replaces the hyphens with underscores' do
          expect(jadu_xml_file_presenter.filename).to eq "file_l_o_l_biz__v1_.rtf"
        end
      end
    end

    describe "#checksum" do
      it "returns an md5 hexdigest of the file" do
        expect(jadu_xml_file_presenter.checksum).to eq "ee7d09ca06cab35f40f4a6b6d76704a7"
      end
    end
  end
end
