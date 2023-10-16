require 'rails_helper'

RSpec.describe AdditionalClaimantsForm::AdditionalClaimant, type: :form do
  let(:additional_claimant) { described_class.new Claimant.new }

  describe 'validations' do
    [:first_name, :last_name, :address_building, :address_street, :address_locality, :address_post_code].each do |attr|
      it { expect(additional_claimant).to validate_presence_of(attr) }
    end

    it { expect(additional_claimant).to validate_inclusion_of(:title).in_array ['Mr', 'Mrs', 'Miss', 'Ms'] }

    it { expect(additional_claimant).to validate_length_of(:first_name).is_at_most(100) }
    it { expect(additional_claimant).to validate_length_of(:last_name).is_at_most(100) }

    it { expect(additional_claimant).to validate_length_of(:address_building).is_at_most(50) }
    it { expect(additional_claimant).to validate_length_of(:address_street).is_at_most(50) }
    it { expect(additional_claimant).to validate_length_of(:address_locality).is_at_most(50) }
    it { expect(additional_claimant).to validate_length_of(:address_county).is_at_most(50) }
    it { expect(additional_claimant).to validate_length_of(:address_post_code).is_at_most(8) }
  end

  context "claimant with target" do
    let(:additional_claimant) { described_class.new(target) }

    let(:attributes) do
      {
        title: 'Mr', first_name: 'Barrington', last_name: 'Wrigglesworth',
        address_building: '1', address_street: 'High Street',
        address_locality: 'Anytown', address_county: 'Anyfordshire',
        address_post_code: 'AT1 0AA',
        'date_of_birth(1)' => '1999', 'date_of_birth(2)' => '1', 'date_of_birth(3)' => '1'
      }
    end

    let(:target) { Claimant.new }

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
        before { additional_claimant.assign_attributes attributes }

        it "saves the data" do
          expect(target).to receive(:update).with additional_claimant.attributes
          additional_claimant.save
        end

        it 'is true' do
          expect(additional_claimant.save).to be true
        end

        context 'PG::NotNullViolation' do
          before { allow(target).to receive(:update).and_raise(PG::NotNullViolation.new('test')) }

          it "send a data to sentry" do
            fake_scope = double('sentry double')
            expect(Sentry).to receive(:with_scope).and_yield(fake_scope)
            expect(fake_scope).to receive(:set_extras).
              with({
                     old_data: target.attributes,
                     new_data: additional_claimant.attributes
                   })
            # binding.pry
            allow(additional_claimant).to receive(:raise).and_return false
            additional_claimant.save
          end

          it "expect sentry to receive exception" do
            expect(Sentry).to receive(:capture_exception)
            allow(additional_claimant).to receive(:raise).and_return false
            additional_claimant.save
          end

          it "expect to raise an arror" do
            expect { additional_claimant.save }.to raise_error(PG::NotNullViolation, 'test')
          end
        end
      end

      describe 'for invalid attributes' do
        before { allow(additional_claimant).to receive(:valid?).and_return false }

        it 'is not saved' do
          expect(target).not_to receive(:update)
          additional_claimant.save
        end

        it 'is false' do
          expect(additional_claimant.save).to be false
        end
      end

      describe 'when marked for destruction' do
        before { additional_claimant._destroy = 'true' }

        it 'destroys the target' do
          expect(target).to receive :destroy
          additional_claimant.save
        end

        it 'is true' do
          expect(additional_claimant.save).to be true
        end
      end
    end
  end

  context 'shared validation' do
    subject { described_class.new Claimant.new }

    include_examples "Postcode validation",
                     attribute_prefix: 'address',
                     error_message: 'Enter a valid UK postcode. If you live abroad, enter SW55 9QT'
  end
end
