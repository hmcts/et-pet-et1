require 'rails_helper'

RSpec.describe RepresentativePresenter, type: :presenter do
  let(:representative_presenter) { described_class.new representative }
  let(:representative) do
    Representative.new type: :law_centre,
                       organisation_name: 'Better Call Saul', name: 'Saul Goodman',
                       address_building: '1', address_street: 'Lol street',
                       address_locality: 'Lolzville', address_county: 'Lolzfordshire',
                       address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
                       mobile_number: '07956123456', contact_preference: 'post', dx_number: '1'
  end

  it { expect(representative_presenter.type).to eq('Law centre') }
  it { expect(representative_presenter.organisation_name).to eq('Better Call Saul') }
  it { expect(representative_presenter.name).to eq('Saul Goodman') }

  describe '#address' do
    it 'concatenates all address properties with a <br /> tag' do
      expect(representative_presenter.address).
        to eq('1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />')
    end
  end

  it { expect(representative_presenter.telephone_number).to eq('01234567890') }
  it { expect(representative_presenter.mobile_number).to eq('07956123456') }
  it { expect(representative_presenter.dx_number).to eq('1') }
  it { expect(representative_presenter.contact_preference).to eq('Post') }

  describe '#each_item' do
    context 'when target.representative is blank' do
      before { representative_presenter.target = nil }

      it 'yields has_representative no' do
        expect { |b| representative_presenter.each_item(&b) }.to yield_successive_args [:has_representative, 'No']
      end
    end

    context 'when target.representative is not blank' do
      it 'yields all the fields' do
        expect(representative_presenter.to_enum(:each_item)).
          to match_array [[:type, "Law centre"], [:organisation_name, "Better Call Saul"],
                          [:name, "Saul Goodman"], [:address, "1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />"],
                          [:telephone_number, "01234567890"], [:mobile_number, "07956123456"],
                          [:email_address, nil], [:dx_number, "1"], [:contact_preference, "Post"]]
      end
    end
  end
end
