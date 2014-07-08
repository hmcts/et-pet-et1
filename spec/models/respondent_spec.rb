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
end
