require 'rails_helper'
module Refunds
  RSpec.describe OriginalCaseDetailsForm, type: :form do
    let(:refund_attributes) do
      {
        applicant_title: 'mr',
        applicant_first_name: 'Test',
        applicant_last_name: 'User',
        address_changed: true
      }
    end
    let(:refund) { instance_spy(Refund, refund_attributes) }
    let(:form) { described_class.new(refund) }

    describe 'validations' do
      context 'et_case_number' do
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
      context 'eat_case_number' do
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
    end
  end
end
