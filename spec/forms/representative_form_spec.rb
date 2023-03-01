require 'rails_helper'

RSpec.describe RepresentativeForm, type: :form do
  let(:representative) { Representative.new }
  let(:resource)       { Claim.new representative: representative, has_representative: true }

  let(:representative_form) { described_class.new resource }

  describe '#has_representative' do
    it 'is true' do
      expect(representative_form.has_representative).to be true
    end

    it 'can be set to false' do
      representative_form.has_representative = false
      expect(representative_form.has_representative).to be false
    end
  end

  describe '#save' do
    context 'when has_representative? == false' do
      before do
        representative_form.has_representative = 'false'
      end

      it 'destroys the representative relation' do
        expect(representative).to receive :destroy

        representative_form.save
      end
    end
  end

  describe 'validations' do
    context 'when has_representative? == true' do
      before { representative_form.has_representative = 'true' }

      [:type, :name, :address_building, :address_street, :address_locality, :address_post_code].each do |attr|
        it { expect(representative_form).to validate_presence_of(attr) }
      end

      it do
        expect(representative_form).to validate_inclusion_of(:type).in_array \
          ['citizen_advice_bureau', 'free_representation_unit', 'law_centre', 'trade_union',
           'solicitor', 'private_individual', 'trade_association', 'other']
      end

      it { expect(representative_form).to validate_length_of(:name).is_at_most(100) }
      it { expect(representative_form).to validate_length_of(:organisation_name).is_at_most(100) }

      it { expect(representative_form).to validate_length_of(:address_building).is_at_most(50) }
      it { expect(representative_form).to validate_length_of(:address_street).is_at_most(50) }
      it { expect(representative_form).to validate_length_of(:address_locality).is_at_most(50) }
      it { expect(representative_form).to validate_length_of(:address_county).is_at_most(50) }
      it { expect(representative_form).to validate_length_of(:address_post_code).is_at_most(8) }

      it { expect(representative_form).to validate_length_of(:address_telephone_number).is_at_most(21) }
      it { expect(representative_form).to validate_length_of(:mobile_number).is_at_most(21) }
      it { expect(representative_form).to validate_length_of(:dx_number).is_at_most(40) }

      it 'disallows an invalid phone number in address_telephone_number' do
        # Arrange - Give the form an invalid number
        representative_form.address_telephone_number = "invalid"

        # Act - call .valid?
        representative_form.valid?

        # Assert - Check the errors
        expect(representative_form.errors).to include :address_telephone_number
      end

      it 'allows a blank phone number in address_telephone_number' do
        # Arrange - Give the form an invalid number
        representative_form.address_telephone_number = ""

        # Act - call .valid?
        representative_form.valid?

        # Assert - Check the errors
        expect(representative_form.errors).not_to include :address_telephone_number
      end

      it 'allows a nil phone number in address_telephone_number' do
        # Arrange - Give the form an invalid number
        representative_form.address_telephone_number = nil

        # Act - call .valid?
        representative_form.valid?

        # Assert - Check the errors
        expect(representative_form.errors).not_to include :address_telephone_number
      end

      it 'disallows an invalid phone number in mobile_number' do
        # Arrange - Give the form an invalid number
        representative_form.mobile_number = "invalid"

        # Act - call .valid?
        representative_form.valid?

        # Assert - Check the errors
        expect(representative_form.errors).to include :mobile_number
      end

      it 'allows a blank phone number in mobile_number' do
        # Arrange - Give the form an invalid number
        representative_form.mobile_number = ""

        # Act - call .valid?
        representative_form.valid?

        # Assert - Check the errors
        expect(representative_form.errors).not_to include :mobile_number
      end

      it 'allows a nil phone number in mobile_number' do
        # Arrange - Give the form an invalid number
        representative_form.mobile_number = nil

        # Act - call .valid?
        representative_form.valid?

        # Assert - Check the errors
        expect(representative_form.errors).not_to include :mobile_number
      end

      describe "presence of email" do
        describe "when contact_preference != email" do
          before { representative_form.contact_preference = 'post' }

          it { expect(representative_form).not_to validate_presence_of(:email_address) }
        end

        describe "when contact_preference == email" do
          before { representative_form.contact_preference = 'email' }

          it { expect(representative_form).to validate_presence_of(:email_address) }
        end
      end

      describe "presence of dx_number" do
        describe "when contact_preference != dx_number" do
          before { representative_form.contact_preference = 'post' }

          it { expect(representative_form).not_to validate_presence_of(:dx_number) }
        end

        describe "when contact_preference == dx_number" do
          before { representative_form.contact_preference = 'dx_number' }

          it { expect(representative_form).to validate_presence_of(:dx_number) }
        end
      end

    end

    context 'when has_representative? == false' do
      before { representative_form.has_representative = 'false' }

      it 'is valid' do
        expect(representative_form).to be_valid
      end
    end
  end

  describe 'before validation' do
    context 'when contact preference == post' do
      before do
        representative_form.email_address = 'emailgmailcom'
        representative_form.dx_number = 'email@gmail.com'
        representative_form.contact_preference = 'post'
        representative_form.valid?
      end

      it 'email address and dx number should be nil' do
        expect(representative_form).to have_attributes(email_address: nil, dx_number: nil)
      end
    end

    context 'when contact preference == email' do
      before do
        representative_form.contact_preference = 'email'
        representative_form.email_address = 'email@gmail.com'
        representative_form.dx_number = 'email@gmail.com'
        representative_form.valid?
      end

      it 'dx number should be nil' do
        expect(representative_form.dx_number).to be_nil
      end
    end

    context 'when contact preference == dx_number' do
      before do
        representative_form.contact_preference = 'dx_number'
        representative_form.email_address = 'emailgmailcom'
        representative_form.dx_number = 'R000000/00/00'
        representative_form.valid?
      end

      it 'email address should be nil' do
        expect(representative_form.email_address).to be_nil
      end
    end
  end

  describe 'form' do
    subject { representative_form }

    it_behaves_like "a Form",
                    {
                      name: 'Saul Goodman',
                      organisation_name: 'Better Call Saul',
                      type: 'citizen_advice_bureau', dx_number: '1',
                      address_building: '1', address_street: 'High Street',
                      address_locality: 'Anytown', address_county: 'Anyfordshire',
                      address_post_code: 'AT1 0AA', email_address: 'lol@example.com',
                      has_representative: true,
                      contact_preference: 'email'
                    },
                    Claim,
                    ['has_representative']

    describe 'postcode validation' do
      before do
        representative_form.has_representative = 'true'
        representative_form.contact_preference = 'email'
      end

      include_examples "Postcode validation",
                       attribute_prefix: 'address',
                       error_message: 'Enter a valid postcode. If your representative lives abroad, enter SW55 9QT'
      include_examples "Email validation",
                       error_message: 'You have entered an invalid email address'
    end

  end

end
