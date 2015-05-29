require 'rails_helper'

RSpec.describe AdditionalRespondentsForm::AdditionalRespondent, :type => :form do
  subject { described_class.new Respondent.new }

  describe 'validations' do
    %i<name address_building address_street address_locality address_post_code>.each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to ensure_length_of(:name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }

    describe 'presence of ACAS certificate number' do
      describe 'when ACAS number is indicated' do
        before { subject.no_acas_number = 'false' }
        it     { is_expected.to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end

      describe 'when no ACAS number is indicated' do
        before { subject.no_acas_number = 'true' }
        it     { is_expected.not_to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end

      describe 'ACAS format validation' do
        { one_char_ten_digits:  'X123456/12/12',
          two_chars_ten_digits: 'XX123456/12/12'
        }.each do |key, acas_value|
          it "#{key.to_s.humanize} validates correctly" do
            subject.acas_early_conciliation_certificate_number = acas_value
            subject.valid?

            expect(subject.errors[:acas_early_conciliation_certificate_number]).to be_empty
          end
        end

        it 'adds an error if the format is invalid' do
          subject.acas_early_conciliation_certificate_number = 'invalid'
          subject.valid?

          expect(subject.errors[:acas_early_conciliation_certificate_number]).
            to include('You have provided an invalid Acas early conciliation number.')
        end
      end
    end

    describe 'presence of reason explaining no ACAS certificate number' do
      let(:reasons) do
        %w<joint_claimant_has_acas_number acas_has_no_jurisdiction
          employer_contacted_acas interim_relief claim_against_security_services>
      end

      it { is_expected.to validate_inclusion_of(:no_acas_number_reason).in_array reasons }

      describe 'when and ACAS number is given' do
        before { subject.no_acas_number = 'false' }
        it     { is_expected.not_to validate_presence_of(:no_acas_number_reason) }
      end

      describe 'when and ACAS number is given' do
        before { subject.no_acas_number = 'true' }
        it     { is_expected.to validate_presence_of(:no_acas_number_reason) }
      end
    end

    it 'clears acas number when selecting no acas number' do
      subject.acas_early_conciliation_certificate_number = 'acas'
      subject.no_acas_number = 'true'
      subject.valid?

      expect(subject.acas_early_conciliation_certificate_number).to be nil
    end
  end

  include_examples "Postcode validation",
    attribute_prefix: 'address',
    error_message: 'Enter a valid UK postcode. If you live abroad, enter SW55 9QT'

  let(:attributes) do
    {
      name: 'Butch McTaggert', acas_early_conciliation_certificate_number: 'XX123456/12/12',
      address_building: '1', address_street: 'High Street',
      address_locality: 'Anytown', address_county: 'Anyfordshire',
      address_post_code: 'W2 3ED'
    }
  end

  let(:target) { Respondent.new }
  subject { AdditionalRespondentsForm::AdditionalRespondent.new(target) }
  before { allow(subject.target).to receive :enqueue_fee_group_reference_request }

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
