require 'rails_helper'

RSpec.describe FilenameCleaner, type: :service do
  describe '.for' do
    let(:claimants_csv) { claim.additional_claimants_csv }

    context 'when attachment exists' do
      let(:claim) { create :claim }

      it 'returns the filename including the extension' do
        expect(described_class.for(claimants_csv)).to eq 'file.csv'
      end

      context 'when handling filenames with non alphanumeric characters' do
        let(:claim) { create :claim, :non_sanitized_attachment_filenames }

        context 'when underscore = true' do
          it 'returns the filename with underscores' do
            expect(described_class.for(claimants_csv, underscore: true)).to eq 'file_l_o_l_biz__v1_.csv'
          end
        end

        context 'when underscore = false' do
          it 'returns the filename unchanged' do
            expect(described_class.for(claimants_csv)).to eq 'file-l_o_l.biz._v1_.csv'
          end
        end
      end
    end

    context 'when attachment does not exist' do
      let(:claim) { create :claim, :without_additional_claimants_csv }

      it 'returns nil' do
        expect(described_class.for(claimants_csv)).to be_nil
      end
    end
  end
end
