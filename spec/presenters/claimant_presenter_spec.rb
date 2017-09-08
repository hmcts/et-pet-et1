require 'rails_helper'

RSpec.describe ClaimantPresenter, type: :presenter do
  let(:claimant_presenter) { described_class.new claim }
  let(:claim) do
    instance_double 'Claimant',
      title: 'mr', first_name: 'Stevie', last_name: 'Graham', gender: 'male',
      date_of_birth: Date.civil(1985, 1, 15), address_building: '1',
      address_street: 'Lol street', address_locality: 'Lolzville',
      address_county: 'Lolzfordshire', address_post_code: 'LOL B1Z',
      address_telephone_number: '01234567890', mobile_number: '07956123456',
      email_address: 'joe@example.com', contact_preference: 'post',
      special_needs: false
  end

  describe '#full_name' do
    it 'concatenates title, first_name and last_name' do
      expect(claimant_presenter.full_name).to eq('Mr Stevie Graham')
    end
  end

  it { expect(claimant_presenter.gender).to eq('Male') }
  it { expect(claimant_presenter.date_of_birth).to eq('15 January 1985') }

  describe '#address' do
    it 'concatenates all address properties with a <br> tag' do
      expect(claimant_presenter.address).
        to eq('1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />')
    end
  end

  it { expect(claimant_presenter.telephone_number).to eq('01234567890') }
  it { expect(claimant_presenter.mobile_number).to eq('07956123456') }
  it { expect(claimant_presenter.email_address).to eq('joe@example.com') }
  it { expect(claimant_presenter.contact_preference).to eq('Post') }

  describe '#is_disabled' do
    specify { expect(claimant_presenter.is_disabled).to eq('No') }

    context 'when the claimant is disabled' do
      before { allow(claim).to receive(:special_needs).and_return true }
      specify { expect(claimant_presenter.is_disabled).to eq('Yes') }
    end
  end
end
