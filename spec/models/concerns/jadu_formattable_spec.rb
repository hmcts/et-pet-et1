require 'rails_helper'

describe JaduFormattable, :type => :concern do
  let(:timestamp) { DateTime.new(2014, 10, 11, 9, 10, 58) }
  let(:claim) { double }

  subject do
    Class.new do
      include JaduFormattable
      def initialize(claim)
        @claim = claim
      end
    end.new(claim)
  end

  describe '#timestamp' do
    before do
      allow(subject).to receive(:timestamp).and_return(timestamp)
    end

    it 'returns the current time' do
      allow(Time).to receive_message_chain(:zone, :now) { timestmp }
      expect(subject.timestamp).to eq(timestamp)
    end
  end

  describe 'case_type' do
    context 'when single claimant' do
      before { allow(claim).to receive(:claimant_count).and_return(1) }
      it 'returns "Single"' do
        expect(subject.case_type(claim)).to eq('Single')
      end
    end

    context 'when multiple claimants' do
      before { allow(claim).to receive(:claimant_count).and_return(2) }
      it 'returns "Multiple"' do
        expect(subject.case_type(claim)).to eq('Multiple')
      end
    end
  end

  describe '#jurisdiction' do
    context 'when not other claim type' do
      before do
        allow(claim).to receive(:other_claim_details).and_return(nil)
      end

      it 'is "1"' do
       expect(subject.jurisdiction(claim)).to eq(1)
     end
    end

    context 'when other claim type' do
      before do
        allow(claim).to receive(:other_claim_details).and_return('other claim details')
      end

      it 'is "2"' do
        expect(subject.jurisdiction(claim)).to eq(2)
      end
    end
  end

  describe '#remission_indicated' do
    context 'when no remission claimants' do
      before do
        allow(claim).to receive(:remission_claimant_count).and_return(0)
      end

      it 'is "NotRequested"' do
        expect(subject.remission_indicated(claim)).to eq('NotRequested')
      end
    end

    context 'when remission claimants' do
      before do
        allow(claim).to receive(:remission_claimant_count).and_return(1)
      end

      it 'is "Indicated"' do
        expect(subject.remission_indicated(claim)).to eq('Indicated')
      end
    end
  end

  describe '#exemption_code' do
    it 'maps reason to Jadu exemption code' do
      expect(subject.exemption_code('claim_against_security_or_intelligence_services')).to eq('claim_targets')
    end
  end

  describe '#split_first_line' do
    it 'splits into number and name' do
      actual = subject.building_split('123 Some Road')
      expect(actual).to eq(['123', ' Some Road'])
    end

    it 'returns nil when no number' do
      actual = subject.building_split('Some Road')
      expect(actual).to eq(['', 'Some Road'])
    end

    it 'takes only first four digits' do
      actual = subject.building_split('12345 Some Road')
      expect(actual).to eq(['1234', '5 Some Road'])
    end

    it 'only removes digits from start of address' do
      actual = subject.building_split('123 Some 3rd Road')
      expect(actual).to eq(['123', ' Some 3rd Road'])
    end
  end

  describe '#address_number' do
    it 'returns number' do
      actual = subject.address_number('123 Some Road')
      expect(actual).to eq(123)
    end

    it 'return nil when no number' do
      actual = subject.address_number('Some Road')
      expect(actual).to be_nil
    end
  end

  describe "#address_name" do
    it 'returns name without spaces' do
      actual = subject.address_name('123 Some Road')
      expect(actual).to eq('Some Road')
    end
  end
end
