require 'rails_helper'

RSpec.describe JaduXml::RepresentativePresenter, type: :presenter do
  let(:representative) { create :representative }
  subject { described_class.new representative }

  describe "decorated methods" do
    describe "#claimant_or_respondent" do
      it "should return C" do
        expect(subject.claimant_or_respondent).to eq "C"
      end
    end

    describe "#type" do
      it "converts the type using a representative type mapping service" do
        expect(RepresentativeType).
          to receive(:convert_for_jadu).
          with('law_centre').and_call_original

        expect(subject.type).to eq 'Law Centre'
      end
    end
  end
end
