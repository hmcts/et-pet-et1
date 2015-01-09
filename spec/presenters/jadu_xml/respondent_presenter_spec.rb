require 'rails_helper'

RSpec.describe JaduXml::RespondentPresenter, type: :presenter do
  let(:respondent) { Respondent.new }
  subject { described_class.new respondent }

  describe "decorated methods" do
    describe "#acas" do
      it "returns the respondent to be consumed by the acas presenter" do
        expect(subject.acas).to eq respondent
      end
    end
  end
end
