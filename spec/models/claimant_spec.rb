require 'rails_helper'

RSpec.describe Claimant, type: :model do
  let(:claimant) { described_class.new }

  it { is_expected.to have_one :address }

  it_behaves_like "it has an address", :address

  describe '#address' do
    describe 'when the association is empty' do
      it 'prepopulates the association with a bare address' do
        expect(claimant.address).to be_an Address
      end
    end
  end
end
