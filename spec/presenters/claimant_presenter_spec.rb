require 'rails_helper'

RSpec.describe ClaimantPresenter, type: :presenter do
  let(:subject) { described_class.new claim }
  let(:claim) do
    double 'claim',
      title: 'mr', first_name: 'Stevie', last_name: 'Graham', gender: 'male',
      date_of_birth: Date.civil(1985, 1, 15), address_building: '1',
      address_street: 'Lol street', address_locality: 'Lolzville',
      address_county: 'Lolzfordshire', address_post_code: 'LOL B1Z',
      address_telephone_number: '01234567890', mobile_number: '07956123456',
      email_address: 'joe@example.com', contact_preference: 'post',
      special_needs: false, applying_for_remission?: false
  end

  describe '#full_name' do
    it 'concatenates title, first_name and last_name' do
      expect(subject.full_name).to eq('Mr Stevie Graham')
    end
  end

  its(:gender)        { is_expected.to eq('Male') }
  its(:date_of_birth) { is_expected.to eq('15 January 1985') }

  describe '#address' do
    it 'concatenates all address properties with a <br> tag' do
      expect(subject.address).
        to eq('1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />')
    end
  end

  its(:telephone_number)   { is_expected.to eq('01234567890') }
  its(:mobile_number)      { is_expected.to eq('07956123456') }
  its(:email_address)      { is_expected.to eq('joe@example.com') }
  its(:contact_preference) { is_expected.to eq('Post') }

  describe '#is_disabled' do
    specify { expect(subject.is_disabled).to eq('No') }

    context 'when the claimant is disabled' do
      before { allow(claim).to receive(:special_needs).and_return true }
      specify { expect(subject.is_disabled).to eq('Yes') }
    end
  end
end
