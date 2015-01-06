require 'rails_helper'

RSpec.describe CarrierwaveFilename, type: :service do
  describe '.for' do
    context 'attachment exists' do
      let(:claim) { create :claim }
      subject { claim.additional_claimants_csv }

      it 'returns the filename including the extension' do
        expect(described_class.for(subject)).to eq 'file.csv'
      end
    end

    context 'attachment does not exist' do
      let(:claim) { create :claim, :without_additional_claimants_csv }
      subject { claim.additional_claimants_csv }

      it 'returns nil' do
        expect(described_class.for(subject)).to be_nil
      end
    end
  end
end
