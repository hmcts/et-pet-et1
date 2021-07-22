require 'rails_helper'

RSpec.describe AdditionalRespondentsForm::AdditionalRespondent, type: :form do
  let(:additional_respondent) { described_class.new Respondent.new }
  let(:attributes) do
    {
      name: 'Butch McTaggert',
      acas_early_conciliation_certificate_number: 'XX123456/12/12',
      has_acas_number: true,
      address_building: '1', address_street: 'High Street',
      address_locality: 'Anytown', address_county: 'Anyfordshire',
      address_post_code: 'W2 3ED'
    }
  end

  let(:target) { Respondent.new }

  describe 'validations' do
    [:name, :address_building, :address_street, :address_locality, :address_post_code].each do |attr|
      it { expect(additional_respondent).to validate_presence_of(attr) }
    end

    it { expect(additional_respondent).to validate_length_of(:name).is_at_most(100) }

    it { expect(additional_respondent).to validate_length_of(:address_building).is_at_most(50) }
    it { expect(additional_respondent).to validate_length_of(:address_street).is_at_most(50) }
    it { expect(additional_respondent).to validate_length_of(:address_locality).is_at_most(25) }
    it { expect(additional_respondent).to validate_length_of(:address_county).is_at_most(25) }
    it { expect(additional_respondent).to validate_length_of(:address_post_code).is_at_most(8) }

    describe 'presence of ACAS certificate number' do
      describe 'when ACAS number is indicated' do
        before { additional_respondent.has_acas_number = 'true' }
        it     { expect(additional_respondent).to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end

      describe 'when no ACAS number is indicated' do
        before { additional_respondent.has_acas_number = 'false' }
        it     { expect(additional_respondent).not_to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end

      describe 'ACAS format validation' do
        { one_char_ten_digits:  'X123456/12/12',
          two_chars_ten_digits: 'XX123456/12/12' }.each do |key, acas_value|
          it "#{key.to_s.humanize} validates correctly" do
            additional_respondent.has_acas_number = true
            additional_respondent.acas_early_conciliation_certificate_number = acas_value
            additional_respondent.valid?

            expect(additional_respondent.errors[:acas_early_conciliation_certificate_number]).to be_empty
          end
        end

        it 'adds an error if the format is invalid' do
          additional_respondent.has_acas_number = true
          additional_respondent.acas_early_conciliation_certificate_number = 'invalid'
          additional_respondent.valid?

          expect(additional_respondent.errors[:acas_early_conciliation_certificate_number]).
            to include('You have provided an invalid Acas early conciliation number.')
        end
      end
    end

    describe 'presence of reason explaining no ACAS certificate number' do
      let(:reasons) do
        ['joint_claimant_has_acas_number', 'acas_has_no_jurisdiction', 'employer_contacted_acas', 'interim_relief']
      end

      it { expect(additional_respondent).to validate_inclusion_of(:no_acas_number_reason).in_array reasons }

      describe 'when and ACAS number is given' do
        before { additional_respondent.has_acas_number = 'true' }
        it     { expect(additional_respondent).not_to validate_presence_of(:no_acas_number_reason) }
      end

      describe 'when and ACAS number is given' do
        before { additional_respondent.has_acas_number = 'false' }
        it     { expect(additional_respondent).to validate_presence_of(:no_acas_number_reason) }
      end
    end

    it 'clears acas number when selecting no acas number' do
      additional_respondent.acas_early_conciliation_certificate_number = 'acas'
      additional_respondent.has_acas_number = 'false'
      additional_respondent.valid?

      expect(additional_respondent.acas_early_conciliation_certificate_number).to be nil
    end
  end

  context 'with target' do
    let(:additional_respondent) { AdditionalRespondentsForm::AdditionalRespondent.new(target) }

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
        before { additional_respondent.assign_attributes attributes }

        it "saves the data" do
          expect(target).to receive(:update).with additional_respondent.attributes
          additional_respondent.save
        end

        it 'is true' do
          expect(additional_respondent.save).to be true
        end
      end

      describe 'for invalid attributes' do
        before { allow(additional_respondent).to receive(:valid?).and_return false }

        it 'is not saved' do
          expect(target).not_to receive(:update)
          additional_respondent.save
        end

        it 'is false' do
          expect(additional_respondent.save).to be false
        end
      end

      describe 'when marked for destruction' do
        before { additional_respondent._destroy = 'true' }

        it 'destroys the target' do
          expect(target).to receive :destroy
          additional_respondent.save
        end

        it 'is true' do
          expect(additional_respondent.save).to be true
        end
      end
    end
  end

  context 'shared validation' do
    subject { additional_respondent }

    include_examples "Postcode validation",
      attribute_prefix: 'address',
      error_message: 'Enter a valid UK postcode. If you live abroad, enter SW55 9QT'
  end
end
