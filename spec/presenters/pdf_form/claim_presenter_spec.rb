require 'rails_helper'

RSpec.describe PdfForm::ClaimPresenter, type: :presenter do
  subject { described_class.new(claim) }

  describe '#name' do
    let(:claimant) { double 'Claimant', first_name: 'first', last_name: 'last' }
    let(:claim) { double 'Claim', primary_claimant: claimant }

    it 'returns a name' do
      expect(subject.name).to eq('first last')
    end
  end

  describe '#to_h' do
    let(:hash) { subject.to_h }

    context 'when owed' do
      %i<notice holiday arrears other>.each do |type|
        let(:claim) { Claim.new pay_claims: [type] }

        it "returns yes when '#{type}' pay complaint" do
          expect(hash).to include('8.1 owed' => 'yes')
        end
      end
    end

    context 'when redundancy' do
      let(:claim) { Claim.new pay_claims: ['redundancy'] }
      it "returns Off when 'redundancy' pay complaint" do
        expect(hash).to include('8.1 owed' => 'Off')
      end
    end

    context 'when whistleblowing' do
      let(:claim) { Claim.new send_claim_to_whistleblowing_entity: true }
      it 'returns yes when whistleblowing' do
        expect(hash).to include('10.1' => 'yes')
      end
    end
  end
end
