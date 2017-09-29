require 'rails_helper'
module Refunds
  RSpec.describe BankDetailsForm, type: :form do
    let(:refund) { instance_spy(Refund) }
    let(:form) { described_class.new(refund) }

    describe 'validations' do
      context 'payment_account_type' do
        it 'validates presence' do
          expect(form).to validate_presence_of(:payment_account_type)
        end

        it 'validates inclusion' do
          expect(form).to validate_inclusion_of(:payment_account_type).in_array(['bank', 'building_society'])
        end
      end

      context 'with payment_account_type as bank' do
        before { form.payment_account_type = 'bank' }

        context 'payment_bank_account_name' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_bank_account_name)
          end
        end
        context 'payment_bank_name' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_bank_name)
          end
        end
        context 'payment_bank_account_number' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_bank_account_number)
          end
        end
        context 'payment_bank_sort_code' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_bank_sort_code)
          end
        end
      end

      context 'with payment_account_type as building_society' do
        before { form.payment_account_type = 'building_society' }

        context 'payment_building_society_account_name' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_building_society_account_name)
          end
        end
        context 'payment_building_society_name' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_building_society_name)
          end
        end
        context 'payment_building_society_account_number' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_building_society_account_number)
          end
        end
        context 'payment_building_society_sort_code' do
          it 'validates presence' do
            expect(form).to validate_presence_of(:payment_building_society_sort_code)
          end
        end
      end
    end

    it_behaves_like 'a Form',
      {
        payment_account_type: 'bank',
        payment_bank_account_name: 'Mr Skywalker',
        payment_bank_name: 'Starship Bank',
        payment_bank_account_number: '12345678',
        payment_bank_sort_code: '123456'
      }, Refund
  end
end
