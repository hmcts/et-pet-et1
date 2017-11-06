require 'rails_helper'
module Refunds
  RSpec.describe FeesForm, type: :form do
    let(:session_attributes) { Refund.new.attributes.to_h }
    let(:refund_session) { double('Session', session_attributes) }
    let(:form) { described_class.new(refund_session) }

    it_behaves_like 'a Form', {}, Session
    describe 'validation' do
      # Start of shared examples
      # As we are testing all 5 fees in the same way, some shared examples
      # are defined below.
      # These should stay in this file to make the test more readable
      shared_examples 'a positive fee with known date' do |fee_name:, fee:|
        fee_payment_date_field = "#{fee_name}_fee_payment_date".to_sym
        fee_payment_method_field = "#{fee_name}_fee_payment_method".to_sym
        before { form.send("#{fee_name}_fee=".to_sym, fee) }
        context "#{fee_payment_date_field} attribute" do
          it 'validates presence' do
            expect(form).to validate_presence_of(fee_payment_date_field)
          end

          it 'validates date allowing valid value using partial date without day' do
            form.send("#{fee_payment_date_field}=".to_sym, ActionController::Parameters.new(month: '12', year: '2016'))
            form.valid?
            expect(form.errors).not_to include fee_payment_date_field
          end

          it 'validates date allowing a ruby date' do
            form.send("#{fee_payment_date_field}=".to_sym, Date.parse('1 December 2016'))
            form.valid?
            expect(form.errors).not_to include fee_payment_date_field
          end

          it 'validates date disallowing value past end date using partial date without day' do
            form.send("#{fee_payment_date_field}=".to_sym, ActionController::Parameters.new(month: '9', year: '2017'))
            form.valid?
            expect(form.errors[fee_payment_date_field]).to include I18n.t("activemodel.errors.models.refunds/fees.attributes.#{fee_payment_date_field}.date_range", start_date: 'July 2013', end_date: 'August 2017')
          end

          it 'validates date disallowing a ruby date which is past the end date' do
            date = Date.parse('1 September 2017')
            form.send("#{fee_payment_date_field}=".to_sym, date)
            form.valid?
            expect(form.errors[fee_payment_date_field]).to include I18n.t("activemodel.errors.models.refunds/fees.attributes.#{fee_payment_date_field}.date_range", start_date: 'July 2013', end_date: 'August 2017')
          end

          it 'validates date disallowing value before start date using partial date without day' do
            form.send("#{fee_payment_date_field}=".to_sym, ActionController::Parameters.new(month: '6', year: '2013'))
            form.valid?
            expect(form.errors[fee_payment_date_field]).to include I18n.t("activemodel.errors.models.refunds/fees.attributes.#{fee_payment_date_field}.date_range", start_date: 'July 2013', end_date: 'August 2017')
          end

          it 'validates date disallowing a ruby date which is before the start date' do
            date = Date.parse('30 June 2013')
            form.send("#{fee_payment_date_field}=".to_sym, date)
            form.valid?
            expect(form.errors[fee_payment_date_field]).to include I18n.t("activemodel.errors.models.refunds/fees.attributes.#{fee_payment_date_field}.date_range", start_date: 'July 2013', end_date: 'August 2017')
          end

          it 'validates date disallowing invalid value using partial date without day' do
            form.send("#{fee_payment_date_field}=".to_sym, ActionController::Parameters.new(month: '13', year: '2016'))
            form.valid?
            expect(form.errors).to include fee_payment_date_field
          end

          it 'validates date disallowing blank value' do
            form.send("#{fee_payment_date_field}=".to_sym, ActionController::Parameters.new(month: '', year: ''))
            form.valid?
            expect(form.errors).to include fee_payment_date_field
          end
        end

        context "#{fee_payment_method_field} attribute" do
          it 'validates presence' do
            expect(form).to validate_presence_of(fee_payment_method_field)
          end

          it 'validates inclusion of correct payment methods' do
            expect(form).to validate_inclusion_of(fee_payment_method_field).
              in_array(['card', 'cheque', 'cash', 'unknown']).
              allow_blank(false)
          end
        end
      end

      shared_examples 'a positive fee with unknown date' do |fee_name:, fee:|
        fee_payment_date_field = "#{fee_name}_fee_payment_date".to_sym
        before do
          form.send("#{fee_name}_fee=".to_sym, fee)
          form.send("#{fee_name}_fee_payment_date_unknown=", true)
        end

        context "#{fee_payment_date_field} attribute" do
          it 'does not validate presence' do
            expect(form).not_to validate_presence_of(fee_payment_date_field)
          end

          it 'does not validate date - blank value' do
            form.send("#{fee_payment_date_field}=".to_sym, ActionController::Parameters.new(month: '', year: ''))
            form.valid?
            expect(form.errors).not_to include fee_payment_date_field
          end
        end
      end

      shared_examples 'a zero or nil fee' do |fee_name:, fee:|
        fee_payment_date_field = "#{fee_name}_fee_payment_date".to_sym
        fee_payment_method_field = "#{fee_name}_fee_payment_method".to_sym
        before { form.send("#{fee_name}_fee=", fee) }
        context "#{fee_payment_date_field} attribute" do
          it 'does not validate presence' do
            expect(form).not_to validate_presence_of(fee_payment_date_field)
          end

          it 'does not validate date - blank value' do
            form.send("#{fee_payment_date_field}=".to_sym, ActionController::Parameters.new(month: '', year: ''))
            form.valid?
            expect(form.errors).not_to include fee_payment_date_field
          end
        end

        context "#{fee_payment_method_field} attribute" do
          it 'does not validate presence' do
            expect(form).not_to validate_presence_of(fee_payment_method_field)
          end
        end
      end

      # Start of validation specs
      context 'with positive fees as float with known date' do
        include_examples 'a positive fee with known date', fee_name: :et_issue, fee: 0.01
        include_examples 'a positive fee with known date', fee_name: :et_hearing, fee: 0.01
        include_examples 'a positive fee with known date', fee_name: :et_reconsideration, fee: 0.01
        include_examples 'a positive fee with known date', fee_name: :eat_issue, fee: 0.01
        include_examples 'a positive fee with known date', fee_name: :eat_hearing, fee: 0.01
      end

      context 'with positive fees as string with known date' do
        include_examples 'a positive fee with known date', fee_name: :et_issue, fee: '0.01'
        include_examples 'a positive fee with known date', fee_name: :et_hearing, fee: '0.01'
        include_examples 'a positive fee with known date', fee_name: :et_reconsideration, fee: '0.01'
        include_examples 'a positive fee with known date', fee_name: :eat_issue, fee: '0.01'
        include_examples 'a positive fee with known date', fee_name: :eat_hearing, fee: '0.01'
      end

      context 'with positive fees as float with unknown date' do
        include_examples 'a positive fee with unknown date', fee_name: :et_issue, fee: 0.01
        include_examples 'a positive fee with unknown date', fee_name: :et_hearing, fee: 0.01
        include_examples 'a positive fee with unknown date', fee_name: :et_reconsideration, fee: 0.01
        include_examples 'a positive fee with unknown date', fee_name: :eat_issue, fee: 0.01
        include_examples 'a positive fee with unknown date', fee_name: :eat_hearing, fee: 0.01
      end

      context 'with positive fees as string with unknown date' do
        include_examples 'a positive fee with unknown date', fee_name: :et_issue, fee: '0.01'
        include_examples 'a positive fee with unknown date', fee_name: :et_hearing, fee: '0.01'
        include_examples 'a positive fee with unknown date', fee_name: :et_reconsideration, fee: '0.01'
        include_examples 'a positive fee with unknown date', fee_name: :eat_issue, fee: '0.01'
        include_examples 'a positive fee with unknown date', fee_name: :eat_hearing, fee: '0.01'
      end

      context 'with no fees' do
        include_examples 'a zero or nil fee', fee_name: :et_issue, fee: nil
        include_examples 'a zero or nil fee', fee_name: :et_hearing, fee: nil
        include_examples 'a zero or nil fee', fee_name: :et_reconsideration, fee: nil
        include_examples 'a zero or nil fee', fee_name: :eat_issue, fee: nil
        include_examples 'a zero or nil fee', fee_name: :eat_hearing, fee: nil
      end

      context 'with zero fees' do
        include_examples 'a zero or nil fee', fee_name: :et_issue, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :et_hearing, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :et_reconsideration, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :eat_issue, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :eat_hearing, fee: 0.0
      end
    end

    context 'attribute writers' do
      shared_examples 'a fee date writer' do |fee_name:|
        reader_method = "#{fee_name}_fee_payment_date".to_sym
        writer_method = "#{fee_name}_fee_payment_date=".to_sym
        it 'converts a partial date from a hash' do
          form.send(writer_method, 'month' => '12', 'year' => '2016')
          expect(form.send(reader_method)).to eql Date.parse('1 December 2016')
        end

        it 'converts an empty partial date from a hash to nil' do
          form.send(writer_method, 'month' => '', 'year' => '')
          expect(form.send(reader_method)).to be_nil
        end

        it 'converts a full date from a hash' do
          form.send(writer_method, 'month' => '12', 'year' => '2016', 'day' => '12')
          expect(form.send(reader_method)).to eql Date.parse('12 December 2016')
        end

        it 'converts a full date from a yyyy-mm-dd string' do
          form.send(writer_method, '2016-12-24')
          expect(form.send(reader_method)).to eql Date.parse('24 December 2016')
        end

        it 'leaves an invalid date from a hash as is' do
          form.send(writer_method, 'month' => '13', 'year' => '2016')
          expect(form.send(reader_method)).to eql('month' => '13', 'year' => '2016', 'day' => '1')
        end

        it 'converts a partial date from an action controller params instance' do
          form.send(writer_method, ActionController::Parameters.new('month' => '12', 'year' => '2016'))
          expect(form.send(reader_method)).to eql Date.parse('1 December 2016')
        end

        it 'converts an empty partial date from an action controller params instance to nil' do
          form.send(writer_method, ActionController::Parameters.new('month' => '', 'year' => ''))
          expect(form.send(reader_method)).to be_nil
        end

        it 'converts a full date from an action controller params instance' do
          form.send(writer_method, ActionController::Parameters.new('month' => '12', 'year' => '2016', 'day' => '10'))
          expect(form.send(reader_method)).to eql Date.parse('10 December 2016')
        end

        it 'leaves an invalid date as a hash from an action controller params instance as is' do
          form.send(writer_method, ActionController::Parameters.new('month' => '13', 'year' => '2016'))
          expect(form.send(reader_method)).to eql('month' => '13', 'year' => '2016', 'day' => '1')
        end

        it 'does not convert nil' do
          form.send(writer_method, nil)
          expect(form.send(reader_method)).to be_nil
        end
      end

      context 'fee date writers' do
        include_examples 'a fee date writer', fee_name: :et_issue
        include_examples 'a fee date writer', fee_name: :et_hearing
        include_examples 'a fee date writer', fee_name: :et_reconsideration
        include_examples 'a fee date writer', fee_name: :eat_issue
        include_examples 'a fee date writer', fee_name: :eat_hearing
      end
    end
  end
end
