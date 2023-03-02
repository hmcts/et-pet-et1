require 'rails_helper'

RSpec.describe Representative, type: :model do
  let(:representative) { described_class.new }

  it { is_expected.to have_one :address }
  it { is_expected.to belong_to(:claim).optional }

  it_behaves_like "it has an address", :address

  describe '#address' do
    describe 'when the association is empty' do
      it 'prepopulates the association with a bare address' do
        expect(representative.address).to be_an Address
      end
    end
  end
end
