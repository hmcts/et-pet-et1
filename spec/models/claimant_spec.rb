require 'rails_helper'

RSpec.describe Claimant, type: :model do
  it { is_expected.to have_one :address }
  it_behaves_like "it has an address", :address

  let(:claimant) { described_class.new }

  describe '#address' do
    describe 'when the association is empty' do
      it 'prepopulates the association with a bare address' do
        expect(claimant.address).to be_an Address
      end
    end
  end
end
