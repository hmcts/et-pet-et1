require 'rails_helper'

RSpec.describe Respondent, :type => :model do
  it { is_expected.to belong_to(:claim) }
  it { is_expected.to have_many(:addresses) }

  it_behaves_like "it has an address", :address
  it_behaves_like "it has an address", :work_address

  describe '#addresses' do
    describe 'when the association is empty' do
      it 'prepopulates the association with two bare addresses' do
        expect(subject.addresses.length).to eq(2)
      end
    end
  end

  describe '#address' do
    specify { expect(subject.address).to eq(subject.addresses.first) }
  end

  describe '#work_address' do
    specify { expect(subject.work_address).to eq(subject.addresses.second) }
  end


  describe '#save' do
    describe 'enqueueing the fee group reference request' do
      let(:claim) { Claim.new }
      subject     { Respondent.new claim: claim }
      
      context 'when the respondent has one address' do
        context 'and the post code has changed' do
          before { subject.address.post_code = 'W1F 7JG' }

          it 'enqueues a fee group reference request with that post code' do
            expect(FeeGroupReferenceJob).to receive(:enqueue).with(claim, 'W1F 7JG')

            subject.save
          end
        end

        context 'and the post code has not changed' do
          before { subject.address.update post_code: 'W1F 7JG' }

          it 'does not enqueue a fee group reference request' do
            expect(FeeGroupReferenceJob).not_to receive(:enqueue)

            subject.save
          end
        end
      end

      context 'when the respondent has a secondary address' do
        context 'and the post code has changed' do
          before do
            subject.address.post_code = 'W1F 7JG'
            subject.work_address.post_code = 'SW1A 1AA'
          end

          it 'enqueues a fee group reference request with that post code' do
            expect(FeeGroupReferenceJob).to receive(:enqueue).with(claim, 'SW1A 1AA')

            subject.save
          end
        end

        context 'and the post code has not changed' do
          before { subject.work_address.update post_code: 'SW1A 1AA' }

          it 'does not enqueue a fee group reference request' do
            expect(FeeGroupReferenceJob).not_to receive(:enqueue)

            subject.save
          end
        end
      end
    end
  end
end
