require 'rails_helper'

RSpec.describe AdditionalClaimantsForm::AdditionalClaimant, :type => :form do
  subject { described_class.new Claimant.new }

  describe 'validations' do
    %i[
      first_name last_name address_building address_street address_locality
      address_post_code
    ].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to validate_inclusion_of(:title).in_array %w<mr mrs miss ms> }

    it { is_expected.to ensure_length_of(:first_name).is_at_most(100) }
    it { is_expected.to ensure_length_of(:last_name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }
  end

  include_examples "Postcode validation",
    attribute_prefix: 'address',
    error_message: 'Enter a valid UK postcode. If you live abroad, enter SW55 9QT'

  let(:attributes) do
    {
      title: 'mr', first_name: 'Barrington', last_name: 'Wrigglesworth',
      address_building: '1', address_street: 'High Street',
      address_locality: 'Anytown', address_county: 'Anyfordshire',
      address_post_code: 'AT1 0AA', date_of_birth: '01/01/1990'
    }
  end

  let(:target) { Claimant.new }
  subject { AdditionalClaimantsForm::AdditionalClaimant.new(target) }

  describe '.model_name_i18n_key' do
    specify do
      expect(described_class.model_name_i18n_key).
        to eq(described_class.model_name.i18n_key)
    end
  end

  describe '#column_for_attribute' do
    it "returns the attribute's type"
  end

  describe '#save' do
    describe 'for valid attributes' do
      before { subject.assign_attributes attributes }

      it "saves the data" do
        expect(target).to receive(:update_attributes).with subject.attributes
        subject.save
      end

      it 'is true' do
        expect(subject.save).to be true
      end

      context 'PG::NotNullViolation' do
        before { allow(target).to receive(:update_attributes).and_raise(PG::NotNullViolation.new('test'))}
        let(:old_data) { target.attributes }

        it "send a data to sentry" do
          expect(Raven).to receive(:extra_context).with(old_data: target.attributes, new_data: subject.attributes)
          expect(Raven).to receive(:capture_exception)
          expect{ subject.save }.to raise_error(PG::NotNullViolation, 'test')
        end
      end
    end

    describe 'for invalid attributes' do
      before { allow(subject).to receive(:valid?).and_return false }

      it 'is not saved' do
        expect(target).to_not receive(:update_attributes)
        subject.save
      end

      it 'is false' do
        expect(subject.save).to be false
      end
    end

    describe 'when marked for destruction' do
      before { subject._destroy = 'true' }

      it 'destroys the target' do
        expect(target).to receive :destroy
        subject.save
      end

      it 'is true' do
        expect(subject.save).to be true
      end
    end
  end
end
