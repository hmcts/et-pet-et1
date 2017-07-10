require 'rails_helper'

RSpec.describe RepresentativePresenter, type: :presenter do
  let(:subject) { described_class.new representative }
  let(:representative) do
    Representative.new type: :law_centre,
      organisation_name: 'Better Call Saul', name: 'Saul Goodman',
      address_building: '1', address_street: 'Lol street',
      address_locality: 'Lolzville', address_county: 'Lolzfordshire',
      address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
      mobile_number: '07956123456', contact_preference: 'post', dx_number: '1'
  end

  its(:type)              { is_expected.to eq('Law centre') }
  its(:organisation_name) { is_expected.to eq('Better Call Saul') }
  its(:name)              { is_expected.to eq('Saul Goodman') }

  describe '#address' do
    it 'concatenates all address properties with a <br /> tag' do
      expect(subject.address).
        to eq('1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />')
    end
  end

  its(:telephone_number)   { is_expected.to eq('01234567890') }
  its(:mobile_number)      { is_expected.to eq('07956123456') }
  its(:dx_number)          { is_expected.to eq('1') }
  its(:contact_preference) { is_expected.to eq('Post') }

  describe '#each_item' do
    context 'when target.representative is blank' do
      before { subject.target = nil }

      it 'yields has_representative no' do
        expect { |b| subject.each_item &b }.to yield_successive_args [:has_representative, 'No']
      end
    end

    context 'when target.representative is not blank' do
      it 'yields all the fields' do
        expect(subject.to_enum(:each_item)).
          to match_array [[:type, "Law centre"], [:organisation_name, "Better Call Saul"],
            [:name, "Saul Goodman"], [:address, "1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />"],
            [:telephone_number, "01234567890"], [:mobile_number, "07956123456"],
            [:email_address, nil], [:dx_number, "1"], [:contact_preference, "Post"]]
      end
    end
  end
end
