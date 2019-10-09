require 'rails_helper'

RSpec.describe ClaimantForm, type: :form do
  let(:claimant) { Claimant.new contact_preference: 'email' }
  let(:resource) { Claim.new primary_claimant: claimant }

  let(:claimant_form) { described_class.new Claim.new primary_claimant: claimant }

  describe 'validations' do
    describe 'on address_post_code' do
      context 'when address_country is united_kingdom' do
        before { claimant_form.address_country = 'united_kingdom' }

        it { expect(claimant_form).to validate_length_of(:address_post_code).is_at_most(8) }
      end

      context 'when address_country is not united_kingdom' do
        before { claimant_form.address_country = 'other' }

        it { expect(claimant_form).not_to validate_length_of(:address_post_code).is_at_most(8) }

        it 'allows illegal (from a UK p.o.v) postcodes' do
          claimant_form.address_post_code = "obviously shabby"
          claimant_form.valid?

          expect(claimant_form.errors[:address_post_code]).to be_empty
        end
      end
    end

    [:first_name, :last_name, :address_building, :address_street, :address_locality, :address_post_code].each do |attr|
      it { expect(claimant_form).to validate_presence_of(attr) }
    end

    it { expect(claimant_form).to validate_inclusion_of(:title).in_array ['mr', 'mrs', 'miss', 'ms'] }
    it { expect(claimant_form).to validate_inclusion_of(:gender).in_array ['male', 'female', 'prefer_not_to_say'] }
    it { expect(claimant_form).to validate_inclusion_of(:contact_preference).in_array ['email', 'post'] }

    it { expect(claimant_form).to validate_length_of(:first_name).is_at_most(100) }
    it { expect(claimant_form).to validate_length_of(:last_name).is_at_most(100) }

    it { expect(claimant_form).to validate_length_of(:address_building).is_at_most(75) }
    it { expect(claimant_form).to validate_length_of(:address_street).is_at_most(75) }
    it { expect(claimant_form).to validate_length_of(:address_locality).is_at_most(25) }
    it { expect(claimant_form).to validate_length_of(:address_county).is_at_most(25) }
    it { expect(claimant_form).to validate_inclusion_of(:address_country).in_array ['united_kingdom', 'other'] }

    [:address_telephone_number, :mobile_number, :fax_number].each do |number|
      it { expect(claimant_form).to validate_length_of(number).is_at_most(21) }
    end

    describe "presence of fax" do
      describe "when contact_preference != fax" do
        before { claimant_form.contact_preference = 'email'}

        it { expect(claimant_form).not_to validate_presence_of(:fax_number) }
      end

      describe "when contact_preference == fax" do
        before { claimant_form.contact_preference = 'fax'}

        it { expect(claimant_form).to validate_presence_of(:fax_number) }
      end
    end

    describe "presence of email" do
      describe "when contact_preference != email" do
        before { claimant_form.contact_preference = 'fax'}

        it { expect(claimant_form).not_to validate_presence_of(:email_address) }
      end

      describe "when contact_preference == email" do
        before { claimant_form.contact_preference = 'email'}

        it { expect(claimant_form).to validate_presence_of(:email_address) }
      end
    end
  end

  describe 'callbacks' do
    it 'clears special needs when selecting no' do
      claimant_form.special_needs = 'uses a crutch'
      claimant_form.has_special_needs = 'false'
      claimant_form.valid?

      expect(claimant_form.special_needs).to be nil
    end

    it 'clears the email address if contact preference is post' do
      claimant_form.email_address = 'test@example.com'
      claimant_form.contact_preference = 'post'

      claimant_form.valid?

      expect(claimant_form.email_address).to be_nil
    end

    it 'does not clear the email address if contact preference is email' do
      claimant_form.email_address = 'test@example.com'
      claimant_form.contact_preference = 'email'

      claimant_form.valid?

      expect(claimant_form.email_address).to eql 'test@example.com'
    end

  end

  describe 'overridden attribute setters' do
    [:first_name, :last_name].each do |attribute|
      it "strips whitespace from the #{attribute}" do
        claimant_form.send "#{attribute}=", ' Such '
        expect(claimant_form.send(attribute)).to eq 'Such'
      end
    end
  end

  context 'shared validations' do
    subject { claimant_form }

    it_behaves_like "a Form",
      title: 'mr',
      gender: 'male',
      contact_preference: 'email',
      first_name: 'Barrington', last_name: 'Wrigglesworth',
      address_building: '1', address_street: 'High Street',
      address_locality: 'Anytown', address_county: 'Anyfordshire',
      address_country: 'united_kingdom',
      address_post_code: 'AT1 0AA', email_address: 'lol@example.com',
      special_needs: '', date_of_birth: '01/01/1990'

    describe 'postcode' do
      before { claimant_form.address_country = 'united_kingdom' }

      include_examples "Postcode validation",
        attribute_prefix: 'address',
        error_message: 'Enter a valid UK postcode. If the claimant lives abroad, enter SW55 9QT'
    end

    include_examples 'Email validation',
      error_message: 'You have entered an invalid email address'
  end
end
