require 'rails_helper'

RSpec.describe CarrierwaveFilename, type: :service do
  describe '.for' do
    context 'attachment exists' do
      let(:claim) { create :claim }
      subject { claim.additional_claimants_csv }

      it 'returns the filename including the extension' do
        expect(described_class.for(subject)).to eq 'file.csv'
      end

      context 'handling hyphenated filenames' do
        let(:claim) { create :claim, :non_sanitized_attachment_filenames }

        context 'when underscore = true' do
          it 'returns the filename with non alphanumerics converted to underscores' do
            expect(described_class.for(subject, underscore: true)).to eq 'file_lol_biz_v1.csv'
          end
        end

        context 'when underscore = false' do
          it 'returns the filename inclusive of non alphanumeric characters' do
            expect(described_class.for(subject)).to eq 'file-lol.biz.v1.csv'
          end
        end
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
