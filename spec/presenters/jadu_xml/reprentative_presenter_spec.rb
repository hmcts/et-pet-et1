require 'rails_helper'

RSpec.describe JaduXml::RepresentativePresenter, type: :presenter do
  let(:representative) { Representative.new }
  subject { described_class.new representative }

  describe "decorated methods" do
    describe "#claimant_or_respondent" do
      it "should return C" do
        expect(subject.claimant_or_respondent).to eq "C"
      end
    end
  end
end
