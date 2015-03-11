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

    describe '#gender' do
      { 'male'              => 'Male',
        'female'            => 'Female',
        'prefer_not_to_say' => 'N/K'
      }.each do |gender, jadu_gender_mapping|
        it "maps #{gender} to #{jadu_gender_mapping}" do
          allow(claimant).to receive(:gender).and_return(gender)
          expect(subject.gender).to eq jadu_gender_mapping
        end
      end
    end

    describe '#date_of_birth' do
      context 'date of birth present' do
        before { claimant.date_of_birth = Date.civil(1960, 01, 12) }
        it 'matches the format dd/mm/yyyy' do
          expect(subject.date_of_birth).to match(/^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/)
          expect(subject.date_of_birth).to eq "12/01/1960"
        end
      end

      context 'date of birth not present' do
        before { claimant.date_of_birth = nil }
        its(:date_of_birth) { is_expected.to be_nil }
      end
    end
  end
end
