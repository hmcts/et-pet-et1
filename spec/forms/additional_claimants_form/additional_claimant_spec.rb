require 'rails_helper'

RSpec.describe AdditionalClaimantsForm::AdditionalClaimant, :type => :form do
  describe 'validations' do
    [:first_name, :last_name, :address_building, :address_street,
     :address_locality, :address_post_code].each do |attr|
       it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to ensure_inclusion_of(:title).in_array %w<mr mrs miss ms> }

    it { is_expected.to ensure_length_of(:first_name).is_at_most(100) }
    it { is_expected.to ensure_length_of(:last_name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }
  end

  include_examples "Postcode validation", attribute_prefix: 'address'

  attributes = {
    title: 'mr', first_name: 'Barrington', last_name: 'Wrigglesworth',
    address_building: '1', address_street: 'High Street',
    address_locality: 'Anytown', address_county: 'Anyfordshire',
    address_post_code: 'AT1 0AA'
  }

  before = proc do
    form.target = target
    allow(resource).to receive(:claimants).and_return proxy
    allow(proxy).to receive(:build).and_return target
  end

  it_behaves_like("a Form", attributes, before)
end
