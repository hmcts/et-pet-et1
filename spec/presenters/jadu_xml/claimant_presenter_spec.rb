require 'rails_helper'

RSpec.describe JaduXml::ClaimantPresenter, type: :presenter do
  let(:claimant) { Claimant.new { |c| c.contact_preference = "email" } }
  subject { described_class.new claimant }

  describe "decorated methods" do
    describe "#contact_preference" do
      it "returns the attribute in humanized form" do
        expect(subject.contact_preference).to eq "Email"
      end
    end
  end
end
