require 'rails_helper'

RSpec.describe Address, type: :model do
  it { is_expected.to belong_to :addressable }

  describe '#empty?' do
    context 'when any attributes are blank' do
      let(:subject) { Address.new }

      specify { expect(subject).to be_empty }
    end

    context 'when no attributes are blank' do
      let(:subject) do
        Address.new building: 'lol', street: 'lol', locality: 'lol', county: 'lol',
          post_code: 'lol', telephone_number: 'lol', country: 'lol'
      end

      specify { expect(subject).not_to be_empty }
    end
  end
end
