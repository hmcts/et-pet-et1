require 'rails_helper'

RSpec.describe JaduXml::RespondentPresenter, type: :presenter do
  let(:respondent) { Respondent.new }
  subject { described_class.new respondent }

  describe "decorated methods" do
    describe "#acas" do
      it "returns a jadu xml acas instance" do
        expect(JaduXml::Acas).to receive(:new).
          with(respondent).and_call_original

        expect(subject.acas).to be_kind_of JaduXml::Acas
      end
    end
  end
end
