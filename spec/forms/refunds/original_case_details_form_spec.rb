require 'rails_helper'
module Refunds
  RSpec.describe OriginalCaseDetailsForm, type: :form do
    # These attributes are required because form objects load these values and
    # make decisions on them at initialization stage
    let(:address_attributes) do
      {
        address_changed: true
      }
    end
    let(:refund_attributes) do
      {
        applicant_title: 'mr',
        applicant_first_name: 'Test',
        applicant_last_name: 'User',
        applicant_email_address: 'test.user@emaildomain.com'
      }.merge(address_attributes)
    end
    let(:session_attributes) { Refund.new(refund_attributes).attributes.to_h }
    let(:refund_session) { Session.new session_attributes }

    let(:form) { described_class.new(refund_session) }

    describe 'before validations' do
      context 'without changed address' do
        let(:address_attributes) do
          {
            address_changed: false,
            applicant_address_building: '102',
            applicant_address_street: 'Petty France',
            applicant_address_locality: 'London',
            applicant_address_county: 'Greater London',
            applicant_address_post_code: 'SW12 3HQ'
          }
        end

        it 'transfers the address' do
          # Act
          form.valid?

          # Assert
          expect(form).to have_attributes claimant_address_building: '102',
                                          claimant_address_street: 'Petty France',
                                          claimant_address_locality: 'London',
                                          claimant_address_county: 'Greater London',
                                          claimant_address_post_code: 'SW12 3HQ'
        end
      end

      context 'with address changed' do
        let(:address_attributes) do
          {
            address_changed: true,
            applicant_address_building: '102',
            applicant_address_street: 'Petty France',
            applicant_address_locality: 'London',
            applicant_address_county: 'Greater London',
            applicant_address_post_code: 'SW12 3HQ'
          }
        end

        it 'does not transfer the address' do
          # Act
          form.valid?

          # Assert
          expect(form).not_to have_attributes claimant_address_building: '102',
                                              claimant_address_street: 'Petty France',
                                              claimant_address_locality: 'London',
                                              claimant_address_county: 'Greater London',
                                              claimant_address_post_code: 'SW12 3HQ'

        end
      end

      it 'transfers personal email' do
        # Act
        form.valid?

        # Assert
        expect(form.claimant_email_address).to eq 'test.user@emaildomain.com'
      end

      it 'transfers name and titleize the title' do
        # Act
        form.valid?

        # Assert
        expect(form.claimant_name).to eql 'Mr Test User'
      end
    end

    describe 'validations' do
      context 'with et_case_number' do
        it 'allows blank' do
          form.et_case_number = ''
          form.valid?
          expect(form.errors).not_to include :et_case_number
        end

        it 'allows the correct format' do
          form.et_case_number = '1234567/2016'
          form.valid?
          expect(form.errors).not_to include :et_case_number
        end

        it 'does not allow more digits before the slash' do
          form.et_case_number = '12345678/2016'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow less digits before the slash' do
          form.et_case_number = '123456/2016'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow a value without the slash' do
          form.et_case_number = '1234567-2016'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow less digits after the slash' do
          form.et_case_number = '1234567/201'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow more digits after the slash' do
          form.et_case_number = '1234567/20161'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow anything but digits before the slash' do
          form.et_case_number = '123456a/2016'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow anything but digits after the slash' do
          form.et_case_number = '1234567/201a'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow 2 slashes - possible confusion with eat number' do
          form.et_case_number = '1234567/2016/1'
          form.valid?
          expect(form.errors).to include :et_case_number
        end

        it 'does not allow 3 slashes - possible confusion with eat number' do
          form.et_case_number = '123456/2016/1/2'
          form.valid?
          expect(form.errors).to include :et_case_number
        end
      end

      context 'with eat_case_number' do
        it 'allows blank' do
          form.eat_case_number = ''
          form.valid?
          expect(form.errors).not_to include :eat_case_number
        end

        it 'allows the correct format' do
          form.eat_case_number = 'UKEAT/1234/16/001'
          form.valid?
          expect(form.errors).not_to include :eat_case_number
        end

        it 'does not allow more digits before the second slash' do
          form.eat_case_number = 'UKEAT/12345/16/001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow less digits before the second slash' do
          form.eat_case_number = 'UKEAT/123/16/001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow a value without any slashes' do
          form.eat_case_number = 'UKEAT 1234 16 001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow less digits after the second slash' do
          form.eat_case_number = 'UKEAT/1234/1/001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow more digits after the second slash' do
          form.eat_case_number = 'UKEAT/1234/167/001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow less digits after the third slash' do
          form.eat_case_number = 'UKEAT/1234/16/01'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow more digits after the third slash' do
          form.eat_case_number = 'UKEAT/1234/16/0001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow anything but UKEAT' do
          form.eat_case_number = 'UKEAS/1234/16/001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow anything but digits after the first slash' do
          form.eat_case_number = 'UKEAT/123a/16/001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow anything but digits after the second slash' do
          form.eat_case_number = 'UKEAT/1234/1a/001'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow anything but digits after the third slash' do
          form.eat_case_number = 'UKEAT/1234/1a/00a'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end

        it 'does not allow number with one slash - possible confusion with et number' do
          form.eat_case_number = '1234567/2016'
          form.valid?
          expect(form.errors).to include :eat_case_number
        end
      end

      context 'when address_changed' do
        it 'validates - allowing true value' do
          form.address_changed = true
          form.valid?
          expect(form.errors).not_to include :address_changed
        end

        it 'validates - allowing false value' do
          form.address_changed = false
          form.valid?
          expect(form.errors).not_to include :address_changed
        end

        it 'validates - disallowing nil value' do
          form.address_changed = nil
          form.valid?
          expect(form.errors).to include :address_changed
        end

        it 'validates - disallowing empty string value' do
          form.address_changed = ''
          form.valid?
          expect(form.errors).to include :address_changed
        end
      end

      context 'with claimant_address_building' do
        it 'validates presence' do
          expect(form).to validate_presence_of(:claimant_address_building)
        end
      end

      context 'with claimant_address_street' do
        it 'validates presence' do
          expect(form).to validate_presence_of(:claimant_address_street)
        end
      end

      context 'with claimant_address_post_code' do
        it 'validates presence' do
          expect(form).to validate_presence_of(:claimant_address_post_code)
        end
      end

      context 'with claim_had_representative' do
        it 'validates - allowing true value' do
          form.claim_had_representative = true
          form.valid?
          expect(form.errors).not_to include :claim_had_representative
        end

        it 'validates - allowing false value' do
          form.claim_had_representative = false
          form.valid?
          expect(form.errors).not_to include :claim_had_representative
        end

        it 'validates - disallowing nil value' do
          form.claim_had_representative = nil
          form.valid?
          expect(form.errors).to include :claim_had_representative
        end

        it 'validates - disallowing empty string value' do
          form.claim_had_representative = ''
          form.valid?
          expect(form.errors).to include :claim_had_representative
        end
      end
    end

    describe 'standard form behavior' do
      attrs = {
        et_country_of_claim: 'england_and_wales',
        claim_had_representative: false,
        address_changed: true,
        claimant_address_building: '1',
        claimant_address_street: 'Street',
        claimant_address_post_code: 'DE21 6QQ',
        respondent_name: 'Mr Resp',
        respondent_address_building: '1',
        respondent_address_street: 'Street'
      }
      it_behaves_like 'a Form', attrs, Session
    end
  end
end
