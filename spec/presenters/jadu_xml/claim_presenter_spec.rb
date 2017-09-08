require 'rails_helper'

RSpec.describe JaduXml::ClaimPresenter, type: :presenter do
  let(:jadu_xml_claim_presenter) { described_class.new claim }

  let(:claim) { Claim.new }

  describe "decorated methods" do
    it { expect(jadu_xml_claim_presenter.claimants).to be_kind_of Enumerable }
    it { expect(jadu_xml_claim_presenter.document_id).to eq claim }
    it { expect(jadu_xml_claim_presenter.submission_channel).to eq "Web" }

    describe "#case_type" do
      context "single claimant" do
        it "returns 'Single'" do
          allow(claim).to receive(:claimant_count).and_return 1
          expect(jadu_xml_claim_presenter.case_type).to eq "Single"
        end
      end

      context "multiple claimants" do
        it "returns 'Multiple'" do
          allow(claim).to receive(:claimant_count).and_return 2
          expect(jadu_xml_claim_presenter.case_type).to eq "Multiple"
        end
      end
    end

    describe "#jurisdiction" do
      context "discrimination or unfair dismissal is true" do
        it "returns 2" do
          allow(claim).to receive(:attracts_higher_fee?).
            and_return true

          expect(jadu_xml_claim_presenter.jurisdiction).to eq 2
        end
      end

      context "discrimination or unfair dismissal is false" do
        it "returns 1" do
          allow(claim).to receive(:attracts_higher_fee?).
            and_return false

          expect(jadu_xml_claim_presenter.jurisdiction).to eq 1
        end
      end
    end

    describe '#office_code' do
      it "delegates to the claims office" do
        expect(claim.office).to receive(:code)
        jadu_xml_claim_presenter.office_code
      end

      it "allows nils" do
        claim.office = nil
        expect { jadu_xml_claim_presenter.office_code }.not_to raise_error
      end
    end

    describe "#date_of_receipt" do
      let(:time) { Time.current }

      it "returns the claims submitted at time" do
        allow(claim).to receive(:submitted_at).and_return time
        expect(jadu_xml_claim_presenter.date_of_receipt).to eq time.xmlschema
      end
    end

    describe "#remission_indicated" do
      context "remission requested" do
        it "returns 'Indicated'" do
          allow(claim).to receive(:remission_claimant_count).and_return 1
          expect(jadu_xml_claim_presenter.remission_indicated).to eq "Indicated"
        end
      end

      context "remission not requested" do
        it "returns 'NotRequested'" do
          allow(claim).to receive(:remission_claimant_count).and_return 0
          expect(jadu_xml_claim_presenter.remission_indicated).to eq "NotRequested"
        end
      end
    end

    it { expect(jadu_xml_claim_presenter.administrator).to eq(-1) }
    it { expect(jadu_xml_claim_presenter.representative).to be_kind_of Array }
    it { expect(jadu_xml_claim_presenter.payment).to eq claim }

    describe "#files" do
      it "delegates to the 'represented' method" do
        expect(claim).to receive(:attachments)
        jadu_xml_claim_presenter.attachments
      end
    end
  end
end
