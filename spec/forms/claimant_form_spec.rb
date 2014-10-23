require 'rails_helper'

RSpec.describe ClaimantForm, :type => :form do
  describe 'validations' do
    [:first_name, :last_name, :address_building, :address_street,
     :address_locality, :address_post_code].each do |attr|
       it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to ensure_inclusion_of(:title).in_array %w<mr mrs miss ms> }
    it { is_expected.to ensure_inclusion_of(:gender).in_array %w<male female prefer_not_to_say> }
    it { is_expected.to ensure_inclusion_of(:contact_preference).in_array %w<email post> }

    it { is_expected.to ensure_length_of(:first_name).is_at_most(100) }
    it { is_expected.to ensure_length_of(:last_name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }
    it { is_expected.to ensure_inclusion_of(:address_country).in_array %w<united_kingdom other> }


    %i<address_telephone_number mobile_number fax_number>.each do |number|
      it { is_expected.to ensure_length_of(number).is_at_most(21) }
    end

    %w<email_address fax_number>.each do |attribute|
      name = attribute.split('_').first

      describe "presence of #{name}" do
        describe "when contact_preference != #{name}" do
          it { is_expected.not_to validate_presence_of(attribute) }
        end

        describe "when contact_preference == #{name}" do
          before { subject.contact_preference = name }
          it { is_expected.to validate_presence_of(attribute) }
        end
      end
    end
  end

  describe '#valid?' do
    it 'clears special needs when selecting no' do
      subject.special_needs = 'uses a crutch'
      subject.has_special_needs = false
      subject.valid?

      expect(subject.special_needs).to be nil
    end
  end

  include_examples "Postcode validation", attribute_prefix: 'address'

  attributes = {
    title: 'mr', gender: 'male', contact_preference: 'email',
    first_name: 'Barrington', last_name: 'Wrigglesworth',
    address_building: '1', address_street: 'High Street',
    address_locality: 'Anytown', address_county: 'Anyfordshire',
    address_country: 'united_kingdom',
    address_post_code: 'AT1 0AA', email_address: 'lol@example.com',
    special_needs: nil
  }

  before = proc do
    allow(resource).to receive(:primary_claimant).and_return nil
    allow(resource).to receive(:build_primary_claimant).and_return target
  end

  it_behaves_like "a Form", attributes, before
  it_behaves_like 'it parses and validates multiparameter dates', :date_of_birth

end
