require 'rails_helper'

RSpec.describe Respondent, type: :model do
  it { is_expected.to belong_to(:claim) }
  it { is_expected.to have_many(:addresses).autosave true }

  it_behaves_like "it has an address", :address
  it_behaves_like "it has an address", :work_address

  let(:claim) { Claim.new }
  let(:respondent) { described_class.new claim: claim }

  describe '#address' do
    specify { expect(respondent.address).to be_primary }
  end

  describe '#work_address' do
    specify { expect(respondent.work_address).not_to be_primary }
  end

  describe '#save' do
    describe 'enqueueing the fee group reference request' do
      context 'when primary_respondent? is false' do
        before do
          respondent.assign_attributes primary_respondent: false, address_post_code: 'W1F 7JG'
        end

        it 'does not enqueue a fee group reference request' do
          expect(FeeGroupReferenceJob).not_to receive(:perform_later)
          respondent.save
        end
      end

      context 'when primary_respondent? is true' do
        before { respondent.primary_respondent = true }

        context 'when the respondent has one address' do
          context 'and the post code has changed' do
            before { respondent.address.post_code = 'W1F 7JG' }

            it 'enqueues a fee group reference request with that post code' do
              expect(FeeGroupReferenceJob).to receive(:perform_later).with(claim)

              respondent.save
            end
          end

          context 'and the post code has not changed' do
            before { respondent.address.update post_code: 'W1F 7JG' }

            it 'does not enqueue a fee group reference request' do
              expect(FeeGroupReferenceJob).not_to receive(:perform_later)

              respondent.save
            end
          end
        end

        context 'when the respondent has a secondary address' do
          context 'and the post code has changed' do
            before do
              respondent.address.post_code = 'W1F 7JG'
              respondent.work_address.post_code = 'SW1A 1AA'
            end

            it 'enqueues a fee group reference request with that post code' do
              expect(FeeGroupReferenceJob).to receive(:perform_later).with(claim)

              respondent.save
            end
          end

          context 'and the post code has not changed' do
            before { respondent.work_address.update post_code: 'SW1A 1AA' }

            it 'does not enqueue a fee group reference request' do
              expect(FeeGroupReferenceJob).not_to receive(:perform_later)

              respondent.save
            end
          end
        end
      end
    end
  end
end
