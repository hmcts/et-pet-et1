require 'rails_helper'

RSpec.describe RespondentForm, :type => :form do
  subject { described_class.new {|f| f.worked_at_same_address = 'false' } }

  work_attributes = {
    work_address_building: "2", work_address_street: "Business Lane",
    work_address_locality: "Business City", work_address_county: 'Businessbury',
    work_address_post_code: "SW1A 1AA", work_address_telephone_number: "01234000000"
  }

  describe 'validations' do
    [:name, :address_building, :address_street, :address_locality,
      :address_post_code].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to ensure_length_of(:name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(75) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }
    it { is_expected.to ensure_length_of(:address_telephone_number).is_at_most(21) }

    it { is_expected.to ensure_length_of(:work_address_building).is_at_most(75) }
    it { is_expected.to ensure_length_of(:work_address_street).is_at_most(75) }
    it { is_expected.to ensure_length_of(:work_address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:work_address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:work_address_post_code).is_at_most(8) }
    it { is_expected.to ensure_length_of(:work_address_telephone_number).is_at_most(21) }

    describe 'presence of work address' do
      describe "when respondent didn't work at a different address" do
        before { subject.worked_at_same_address = 'true' }
        [:work_address_building, :work_address_street, :work_address_locality,
         :work_address_telephone_number, :work_address_post_code].each do |attr|
          it { is_expected.not_to validate_presence_of(attr) }
        end
      end

      describe "when respondent worked at a different address" do
        [:work_address_building, :work_address_street, :work_address_locality,
         :work_address_post_code].each do |attr|
          it { is_expected.to validate_presence_of(attr) }
        end
      end
    end

    describe 'presence of ACAS certificate number' do
      describe 'when no reason is given for its absence' do
        it { is_expected.to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end

      describe 'when no reason is given for its absence' do
        before { subject.no_acas_number = 'true' }
        it { is_expected.not_to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end
    end

    describe 'presence of reason explaining no ACAS certificate number' do
      reasons = ["joint_claimant_has_acas_number", "acas_has_no_jurisdiction",
        "employer_contacted_acas", "interim_relief",
        "claim_against_security_services"]

      it { is_expected.to ensure_inclusion_of(:no_acas_number_reason).in_array reasons }

      describe 'when and ACAS number is given' do
        it { is_expected.not_to validate_presence_of(:no_acas_number_reason) }
      end

      describe 'when and ACAS number is given' do
        before { subject.no_acas_number = true }
        it { is_expected.to validate_presence_of(:no_acas_number_reason) }
      end
    end

    it 'clears acas number when selecting no acas number' do
      subject.acas_early_conciliation_certificate_number = 'acas'
      subject.no_acas_number = true
      subject.valid?

      expect(subject.acas_early_conciliation_certificate_number).to be nil
    end

    context 'when worked at same address' do
      subject { described_class.new work_attributes }
      before { subject.worked_at_same_address = 'true' }

      work_attributes.keys.each do |attr|
        it "clears #{attr} field" do
          subject.valid?

          expect(subject.attributes[attr]).to be nil
        end
      end
    end
  end

  describe '#worked_at_same_address?' do
    it 'true when "true"' do
      subject.worked_at_same_address = 'true'
      expect(subject.worked_at_same_address?).to be true
    end

    it 'false when "false"' do
      subject.worked_at_same_address = 'false'
      expect(subject.worked_at_same_address?).to be false
    end
  end

  include_examples "Postcode validation", attribute_prefix: 'address'
  include_examples "Postcode validation", attribute_prefix: 'work_address'

  let(:model) { Claim.create }
  let(:form) { RespondentForm.new(attributes) { |f| f.resource = model } }
  let(:respondent) { model.respondents.first }

  attributes = {
    name: "Crappy Co. LTD",
    address_telephone_number: "01234567890", address_building: "1",
    address_street: "Business Street", address_locality: "Businesstown",
    address_county: "Businessfordshire", address_post_code: "SW1A 1AB",
    worked_at_same_address: 'false', no_acas_number: "1",
    no_acas_number_reason: "acas_has_no_jurisdiction",
    acas_early_conciliation_certificate_number: nil}.merge(work_attributes)

  before = proc do
    allow(resource).to receive(:primary_respondent).and_return nil
    allow(resource).to receive(:build_primary_respondent).and_return target
  end

  it_behaves_like("a Form", attributes, before)
end
