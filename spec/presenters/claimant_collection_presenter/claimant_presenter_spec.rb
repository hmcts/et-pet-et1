require 'rails_helper'

RSpec.describe ClaimantCollectionPresenter::ClaimantPresenter, type: :presenter do
  let(:subject) { described_class.new claimant }

  let(:claimant) do
    Claimant.new title: 'mr', first_name: 'Stevie', last_name: 'Graham',
      date_of_birth: Date.civil(1985, 1, 15), address_building: '1',
      address_street: 'Lol street', address_locality: 'Lolzville',
      address_county: 'Lolzfordshire', address_post_code: 'LOL B1Z'
  end

  describe '#full_name' do
    it 'concatenates title, first_name and last_name' do
      expect(subject.full_name).to eq('Mr Stevie Graham')
    end
  end

  its(:date_of_birth) { is_expected.to eq('15 January 1985') }

  describe '#address' do
    it 'concatenates all address properties with a <br /> tag' do
      expect(subject.address).
        to eq('1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />')
    end
  end
end
