require 'rails_helper'

RSpec.describe PdfFormBuilder, type: :service do

  context "ET1 Form template" do
    describe "ET1_PDF_PATH" do
      it "returns the path of the template form pdf" do
        file_path = Rails.root.to_s
        expect(described_class::ET1_PDF_PATH).to eq "#{file_path}/lib/assets/et001-eng.pdf"
      end
    end

    it "english exists" do
      file_existence = File.exist?(described_class::ET1_PDF_PATH)
      expect(file_existence).to eq true
    end

    it "welsh exists" do
      file_existence = File.exist?(described_class::ET1_PDF_PATH_CY)
      expect(file_existence).to eq true
    end
  end

  describe ".build" do

    let(:claim) { create :claim }

    it "creates an instance" do
      expect(described_class).to receive(:new).and_call_original
      described_class.build(claim) {}
    end

    context "#perform" do
      it "yields a pdf to the given block" do
        described_class.build(claim) do |file|
          expect(file).to be_kind_of Tempfile
        end
      end
    end
  end
end
