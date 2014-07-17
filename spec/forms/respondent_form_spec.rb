require 'rails_helper'

RSpec.describe RespondentForm, :type => :form do
  describe 'validations' do
    [:name, :address_building, :address_street, :address_locality,
      :address_telephone_number, :address_post_code].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to ensure_length_of(:name).is_at_most(100) }

    it { is_expected.to ensure_length_of(:address_building).is_at_most(30) }
    it { is_expected.to ensure_length_of(:address_street).is_at_most(30) }
    it { is_expected.to ensure_length_of(:address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:address_post_code).is_at_most(8) }
    it { is_expected.to ensure_length_of(:address_telephone_number).is_at_most(15) }

    it { is_expected.to ensure_length_of(:work_address_building).is_at_most(30) }
    it { is_expected.to ensure_length_of(:work_address_street).is_at_most(30) }
    it { is_expected.to ensure_length_of(:work_address_locality).is_at_most(25) }
    it { is_expected.to ensure_length_of(:work_address_county).is_at_most(25) }
    it { is_expected.to ensure_length_of(:work_address_post_code).is_at_most(8) }
    it { is_expected.to ensure_length_of(:work_address_telephone_number).is_at_most(15) }

    describe 'presence of work address' do
      describe "when respondent didn't work at a different address" do
        [:work_address_building, :work_address_street, :work_address_locality,
         :work_address_telephone_number, :work_address_post_code].each do |attr|
          it { is_expected.to_not validate_presence_of(attr) }
        end
      end

      describe "when respondent worked at a different address" do
        before { subject.worked_at_different_address = true }
        [:work_address_building, :work_address_street, :work_address_locality,
         :work_address_telephone_number, :work_address_post_code].each do |attr|
          it { is_expected.to validate_presence_of(attr) }
        end
      end
    end

    describe 'presence of ACAS certificate number' do
      describe 'when no reason is given for its absence' do
        it { is_expected.to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end

      describe 'when no reason is given for its absence' do
        before { subject.no_acas_number = true }
        it { is_expected.to_not validate_presence_of(:acas_early_conciliation_certificate_number) }
      end
    end

    describe 'presence of reason explaining no ACAS certificate number' do
      reasons = ["joint_claimant_has_acas_number", "acas_has_no_jurisdiction",
        "employer_contacted_acas", "interim_relief",
        "claim_against_security_or_intelligence_services"]

      it { is_expected.to ensure_inclusion_of(:no_acas_number_reason).in_array reasons }

      describe 'when and ACAS number is given' do
        it { is_expected.to_not validate_presence_of(:no_acas_number_reason) }
      end

      describe 'when and ACAS number is given' do
        before { subject.no_acas_number = true }
        it { is_expected.to validate_presence_of(:no_acas_number_reason) }
      end
    end
  end

  describe '#save' do
    let(:model) { Claim.create }
    let(:form) { RespondentForm.new(attributes) { |f| f.resource = model } }
    let(:respondent) { model.respondents.first }

    let(:attributes) do
      { "name" => "Crappy Co. LTD",
        "address_telephone_number" => "01234567890", "address_building" => "1",
        "address_street" => "Business Street", "address_locality" => "Businesstown",
        "address_county" => "Businessfordshire", "address_post_code" => "BT1 1CB",
        "work_address_building" => "2", "work_address_street" => "Business Lane",
        "work_address_locality" => "Business City", "work_address_county" => 'Businessbury',
        "work_address_post_code" => "BT2 1CB", "work_address_telephone_number" => "01234000000",
        "worked_at_different_address" => '1', "no_acas_number" => "1",
        "no_acas_number_reason" => "acas_has_no_jurisdiction" }
    end

    before { form.save }

    describe 'for valid attributes' do
      let(:address)      { respondent.addresses.first }
      let(:work_address) { respondent.addresses.last }

      it "adds a respondent to the claim" do
        expect(respondent.attributes).
          to include("name" => "Crappy Co. LTD",
                     "no_acas_number_reason" => "acas_has_no_jurisdiction")
      end

      it "adds a primary address to the respondent" do
        expect(address.attributes).
          to include("building"=>"1", "street"=>"Business Street",
                     "locality"=>"Businesstown", "county"=>"Businessfordshire",
                     "post_code"=>"BT1 1CB")
      end

      it "adds a work address to the respondent" do
        expect(work_address.attributes).
          to include("building"=>"2", "street"=>"Business Lane",
                     "locality"=>"Business City", "county"=>"Businessbury",
                     "post_code"=>"BT2 1CB")
      end
    end

    describe 'for invalid attributes' do
      let(:attributes) { { name: 'derp' } }
      specify { expect(respondent).to be_nil }
    end
  end
end
