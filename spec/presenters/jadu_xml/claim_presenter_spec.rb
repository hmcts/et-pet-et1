require 'rails_helper'

RSpec.describe JaduXml::ClaimPresenter, type: :presenter do
  let(:claim) { Claim.new }
  subject { described_class.new claim }

  describe "decorated methods" do
    its(:claimants) { is_expected.to be_kind_of Enumerable }
    its(:document_id) { is_expected.to eq claim }
    its(:submission_channel) { is_expected.to eq "Web" }

    describe "#case_type" do
      context "single claimant" do
        it "returns 'Single'" do
          allow(claim).to receive(:claimant_count).and_return 1
          expect(subject.case_type).to eq "Single"
        end
      end

      context "multiple claimants" do
        it "returns 'Multiple'" do
          allow(claim).to receive(:claimant_count).and_return 2
          expect(subject.case_type).to eq "Multiple"
        end
      end
    end

    describe "#jurisdiction" do
      context "discrimination or unfair dismissal is true" do
        it "returns 2" do
          allow(claim).to receive(:attracts_higher_fee?).
            and_return true

          expect(subject.jurisdiction).to eq 2
        end
      end

      context "discrimination or unfair dismissal is false" do
        it "returns 1" do
          allow(claim).to receive(:attracts_higher_fee?).
            and_return false

          expect(subject.jurisdiction).to eq 1
        end
      end
    end

    describe '#office_code' do
      it "delegates to the claims office" do
        expect(claim.office).to receive(:code)
        subject.office_code
      end

      it "allows nils" do
        claim.office = nil
        expect { subject.office_code }.not_to raise_error
      end
    end

    describe "#date_of_receipt" do
      let(:time) { Time.now }
      it "returns the claims submitted at time" do
        allow(claim).to receive(:submitted_at).and_return time
        expect(subject.date_of_receipt).to eq time.xmlschema
      end
    end

    describe "#remission_indicated" do
      context "remission requested" do
        it "returns 'Indicated'" do
          allow(claim).to receive(:remission_claimant_count).and_return 1
          expect(subject.remission_indicated).to eq "Indicated"
        end
      end

      context "remission not requested" do
        it "returns 'NotRequested'" do
          allow(claim).to receive(:remission_claimant_count).and_return 0
          expect(subject.remission_indicated).to eq "NotRequested"
        end
      end
    end

    its(:administrator)   { is_expected.to eq -1 }
    its(:representative)  { is_expected.to be_kind_of Array }
    its(:payment)         { is_expected.to eq claim }

    describe "#files" do
      it "delegates to the 'represented' method" do
        expect(claim).to receive(:attachments)
        subject.attachments
      end
    end
  end
end
