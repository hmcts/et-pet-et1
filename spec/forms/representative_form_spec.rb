require 'rails_helper'

RSpec.describe RepresentativeForm, :type => :form do
  describe 'validations' do
    [:name, :address_building, :address_street, :address_locality, :address_post_code].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it do
      is_expected.to ensure_inclusion_of(:type).in_array \
       %w<citizen_advice_bureau free_representation_unit law_centre trade_union
           solicitor private_individual trade_association other>
    end

    it { is_expected.to ensure_length_of(:name).is_at_most(100) }
    it { is_expected.to ensure_length_of(:organisation_name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(30) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(30) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }

    it { is_expected.to ensure_length_of(:address_telephone_number).is_at_most(15) }
    it { is_expected.to ensure_length_of(:mobile_number).is_at_most(15) }
    it { is_expected.to ensure_length_of(:dx_number).is_at_most(20) }
  end

  describe '#save' do
    let(:model) { Claim.create }
    let(:form) { RepresentativeForm.new(attributes) { |f| f.resource = model } }
    let(:representative) { model.representative }

    let(:attributes) do
      { name: 'Saul Goodman', organisation_name: 'Better Call Saul',
        type: 'citizen_advice_bureau', dx_number: '1',
        address_building: '1', address_street: 'High Street',
        address_locality: 'Anytown', address_county: 'Anyfordshire',
        address_post_code: 'AT1 0AA', email_address: 'lol@example.com' }
    end

    before { form.save }

    describe 'for valid attributes' do
      let(:address) { representative.address }

      it "adds a claimant to the claim" do
        expect(representative.attributes).
          to include("name"=>"Saul Goodman", "organisation_name"=>"Better Call Saul",
                     "type"=>"citizen_advice_bureau", "dx_number"=>"1")
      end

      it "adds an address to the claimaint" do
        expect(address.attributes).
          to include("building"=>"1", "street"=>"High Street",
                     "locality"=>"Anytown", "county"=>"Anyfordshire",
                     "post_code"=>"AT1 0AA")
      end
    end

    describe 'for invalid attributes' do
      let(:attributes) { { name: 'derp' } }
      specify { expect(representative).to be_nil }
    end
  end
end
