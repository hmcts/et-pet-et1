require 'rails_helper'

RSpec.describe Claim, :type => :model do
  describe 'state transitions' do
    describe 'moving forward' do
      context 'when there is a representative' do
        let(:claim) { Claim.new has_representative: true }
        it 'transitions via the "representative" state' do
          claim.next
          expect(claim.state).to eq(:representative)
        end
      end

      context 'when there is no representative' do
        let(:claim) { Claim.new }
        it 'does not transition via the "representative" state' do
          claim.next
          expect(claim.state).to eq(:employer)
        end
      end

      context 'when the claimant was employed by the respondent' do
        let(:claim) { Claim.new was_employed: true }
        it 'does not transition via the "representative" state' do
          2.times { claim.next }
          expect(claim.state).to eq(:employment)
        end
      end

      context 'when the claimant was not employed by the respondent' do
        let(:claim) { Claim.new }
        it 'does not transition via the "representative" state' do
          2.times { claim.next }
          expect(claim.state).to eq(:claim)
        end
      end
    end
  end
end
