require 'rails_helper'
module Refunds
  RSpec.describe BankDetailsForm, type: :form do
    let(:session_attributes) { Refund.new.attributes.to_h }
    let(:refund_session) { double('Session', session_attributes) }
    let(:form) { described_class.new(refund_session) }

    describe 'validations' do
      context "payment_bank_account_name" do
        it 'validates presence' do
          expect(form).to validate_presence_of(:"payment_bank_account_name")
        end
      end
      context "payment_bank_name" do
        it 'validates presence' do
          expect(form).to validate_presence_of(:"payment_bank_name")
        end
      end
      context "payment_bank_account_number" do
        it 'validates presence' do
          expect(form).to validate_presence_of(:"payment_bank_account_number")
        end

        it 'allows an 8 digit number' do
          form.send(:"payment_bank_account_number=", '12345678')
          form.valid?
          expect(form.errors).not_to include :"payment_bank_account_number"
        end

        it 'disallows a 7 digit number' do
          form.send(:"payment_bank_account_number=", '1234567')
          form.valid?
          expect(form.errors).to include :"payment_bank_account_number"
        end

        it 'disallows a 9 digit number' do
          form.send(:"payment_bank_account_number=", '123456789')
          form.valid?
          expect(form.errors).to include :"payment_bank_account_number"
        end

        it 'disallows alphas in the number' do
          form.send(:"payment_bank_account_number=", '1234a678')
          form.valid?
          expect(form.errors).to include :"payment_bank_account_number"
        end

        it 'disallows hyphens in the number' do
          form.send(:"payment_bank_account_number=", '123-5678')
          form.valid?
          expect(form.errors).to include :"payment_bank_account_number"
        end

        it 'disallows slashes in the number' do
          form.send(:"payment_bank_account_number=", '123/5678')
          form.valid?
          expect(form.errors).to include :"payment_bank_account_number"
        end
      end

      context "payment_bank_sort_code" do
        it 'validates presence' do
          expect(form).to validate_presence_of(:"payment_bank_sort_code")
        end

        it 'allows a 6 digit number' do
          form.send(:"payment_bank_sort_code=", '123456')
          form.valid?
          expect(form.errors).not_to include :"payment_bank_sort_code"
        end

        it 'disallows a 5 digit number' do
          form.send(:"payment_bank_sort_code=", '12345')
          form.valid?
          expect(form.errors).to include :"payment_bank_sort_code"
        end

        it 'disallows a 7 digit number' do
          form.send(:"payment_bank_sort_code=", '1234567')
          form.valid?
          expect(form.errors).to include :"payment_bank_sort_code"
        end

        it 'disallows alphas in the number' do
          form.send(:"payment_bank_sort_code=", '1234a6')
          form.valid?
          expect(form.errors).to include :"payment_bank_sort_code"
        end

        it 'disallows hyphens in the number' do
          form.send(:"payment_bank_sort_code=", '123-56')
          form.valid?
          expect(form.errors).to include :"payment_bank_sort_code"
        end

        it 'disallows slashes in the number' do
          form.send(:"payment_bank_sort_code=", '123/56')
          form.valid?
          expect(form.errors).to include :"payment_bank_sort_code"
        end
      end
    end

    it_behaves_like 'a Form',
      {
        payment_bank_account_name: 'Mr Skywalker',
        payment_bank_name: 'Starship Bank',
        payment_bank_account_number: '12345678',
        payment_bank_sort_code: '123456'
      }, Session
  end
end
