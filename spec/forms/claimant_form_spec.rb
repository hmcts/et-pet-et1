require 'rails_helper'

RSpec.describe ClaimantForm, :type => :form do
  describe 'validations' do
    [:first_name, :last_name, :address_building, :address_street,
     :address_locality, :address_post_code].each do |attr|
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

    %i<telephone_number mobile_number fax_number>.each do |number|
      it { is_expected.to ensure_length_of(number).is_at_most(15) }
    end

  end
end
