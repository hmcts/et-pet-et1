require 'rails_helper'

RSpec.describe ClaimantForm, :type => :form do
  describe 'validations' do
    [:first_name, :last_name, :address_building, :address_street,
     :address_locality, :address_post_code, :address_county].each do |attr|
       it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to ensure_inclusion_of(:title).in_array %w<mr mrs miss ms> }
    it { is_expected.to ensure_inclusion_of(:gender).in_array %w<male female> }
    it { is_expected.to ensure_inclusion_of(:contact_preference).in_array %w<email post fax> }

    it { is_expected.to ensure_length_of(:first_name).is_at_most(25) }
    it { is_expected.to ensure_length_of(:last_name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(30) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(30) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }

    %i<address_telephone_number mobile_number fax_number>.each do |number|
      it { is_expected.to ensure_length_of(number).is_at_most(15) }
    end

    %w<email_address fax_number>.each do |attribute|
      name = attribute.split('_').first

      describe "presence of #{name}" do
        describe "when contact_preference != #{name}" do
          it { is_expected.to_not validate_presence_of(attribute) }
        end

        describe "when contact_preference == #{name}" do
          before { subject.contact_preference = name }
          it { is_expected.to validate_presence_of(attribute) }
        end
      end
    end
  end

  describe '#save' do
    let(:model) { Claim.create }
    let(:form) { ClaimantForm.new(attributes) { |f| f.resource = model } }
    let(:claimant) { model.claimants.first }

    let(:attributes) do
      { title: 'mr', gender: 'male', contact_preference: 'email',
        first_name: 'Barrington', last_name: 'Wrigglesworth',
        address_building: '1', address_street: 'High Street',
        address_locality: 'Anytown', address_county: 'Anyfordshire',
        address_post_code: 'AT1 0AA', email_address: 'lol@example.com' }
    end

    before { form.save }

    describe 'for valid attributes' do
      let(:address) { claimant.address }

      it "adds a claimant to the claim" do
        expect(claimant.attributes).
          to include("title"=>"mr", "gender"=>"male", "contact_preference"=>"email",
                     "first_name"=>"Barrington", "last_name"=>"Wrigglesworth",
                     "email_address"=>"lol@example.com")
      end

      it "adds an address to the claimaint" do
        expect(address.attributes).
          to include("building"=>"1", "street"=>"High Street",
                     "locality"=>"Anytown", "county"=>"Anyfordshire",
                     "post_code"=>"AT1 0AA")
      end
    end

    describe 'for invalid attributes' do
      let(:attributes) { { first_name: 'derp' } }
      specify { expect(claimant).to be_nil }
    end
  end
end
