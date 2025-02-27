require 'rails_helper'
module Refunds
  RSpec.describe FeesForm, type: :form do
    let(:session_attributes) { Refund.new.attributes.to_h }
    let(:refund_session) { double('Session', session_attributes) }
    let(:form) { described_class.new(refund_session) }

    it_behaves_like 'a Form', {
      et_issue_fee: '12',
      et_issue_fee_payment_method: 'card',
      et_issue_fee_payment_date: { 3 => 1, 2 => 1, 1 => 2016 }
    }, Session

    describe 'validation' do
      # Start of shared examples
      # As we are testing all 5 fees in the same way, some shared examples
      # are defined below.
      # These should stay in this file to make the test more readable
      shared_examples 'a positive fee with known date' do |fee_name:, fee:|
        fee_payment_date_field = :"#{fee_name}_fee_payment_date"
        fee_payment_method_field = :"#{fee_name}_fee_payment_method"
        before { form.send(:"#{fee_name}_fee=", fee) }

        context "with #{fee_payment_date_field} attribute" do
          it 'validates presence' do
            expect(form).to validate_presence_of(fee_payment_date_field)
          end

          it 'validates date allowing valid value using partial date without day' do
            value = { "#{fee_payment_date_field}(2)" => '12',
                      "#{fee_payment_date_field}(1)" => '2016' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field)).to be_empty
          end

          it 'validates date allowing a ruby date' do
            form.send(:"#{fee_payment_date_field}=", Date.parse('1 December 2016'))
            form.valid?
            expect(form.errors.where(fee_payment_date_field)).to be_empty
          end

          it 'validates date disallowing value with 2 digit year' do
            value = { "#{fee_payment_date_field}(2)" => '12',
                      "#{fee_payment_date_field}(1)" => '16' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field, :invalid)).to include(have_attributes(message: "Enter the date in the correct format (DD/MM/YYYY)"))
          end

          it 'validates date disallowing value past end date using partial date without day' do
            value = { "#{fee_payment_date_field}(2)" => '9',
                      "#{fee_payment_date_field}(1)" => '2017' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field, :date_range)).to include(have_attributes(message: 'The payment date must be between July 2013 and August 2017'))
          end

          it 'validates date disallowing a ruby date which is past the end date' do
            date = Date.parse('1 September 2017')
            form.send(:"#{fee_payment_date_field}=", date)
            form.valid?
            expect(form.errors.where(fee_payment_date_field, :date_range)).to include(have_attributes(message: 'The payment date must be between July 2013 and August 2017'))
          end

          it 'validates date disallowing value before start date using partial date without day' do
            value = { "#{fee_payment_date_field}(2)" => '6',
                      "#{fee_payment_date_field}(1)" => '2013' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field, :date_range)).to include(have_attributes(message: 'The payment date must be between July 2013 and August 2017'))
          end

          it 'validates date disallowing a ruby date which is before the start date' do
            date = Date.parse('30 June 2013')
            form.send(:"#{fee_payment_date_field}=", date)
            form.valid?
            expect(form.errors.where(fee_payment_date_field, :date_range)).to include(have_attributes(message: 'The payment date must be between July 2013 and August 2017'))
          end

          it 'validates date disallowing invalid value using partial date without day' do
            value = { "#{fee_payment_date_field}(2)" => '13',
                      "#{fee_payment_date_field}(1)" => '2016' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field, :invalid)).to be_present
          end

          it 'validates date disallowing blank value' do
            value = { "#{fee_payment_date_field}(2)" => '',
                      "#{fee_payment_date_field}(1)" => '' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field)).to be_present
          end
        end

        context "with #{fee_payment_method_field} attribute" do
          it 'validates presence' do
            expect(form).to validate_presence_of(fee_payment_method_field)
          end

          it 'validates inclusion of correct payment methods' do
            expect(form).to validate_inclusion_of(fee_payment_method_field).
              in_array(['card', 'cheque', 'cash', 'unknown'])
          end
        end
      end

      shared_examples 'a positive fee with unknown date' do |fee_name:, fee:|
        fee_payment_date_field = :"#{fee_name}_fee_payment_date"
        before do
          form.send(:"#{fee_name}_fee=", fee)
          form.send("#{fee_name}_fee_payment_date_unknown=", true)
        end

        context "with #{fee_payment_date_field} attribute" do
          it 'does not validate presence' do
            expect(form).not_to validate_presence_of(fee_payment_date_field)
          end

          it 'does not validate date - blank value' do
            value = { "#{fee_payment_date_field}(2)" => '',
                      "#{fee_payment_date_field}(1)" => '' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field)).to be_empty
          end
        end
      end

      shared_examples 'a zero or nil fee' do |fee_name:, fee:|
        fee_payment_date_field = :"#{fee_name}_fee_payment_date"
        fee_payment_method_field = :"#{fee_name}_fee_payment_method"
        before { form.send("#{fee_name}_fee=", fee) }

        context "with #{fee_payment_date_field} attribute" do
          it 'does not validate presence' do
            expect(form).not_to validate_presence_of(fee_payment_date_field)
          end

          it 'does not validate date - blank value' do
            value = { "#{fee_payment_date_field}(2)" => '',
                      "#{fee_payment_date_field}(1)" => '' }
            form.assign_attributes(value)
            form.valid?
            expect(form.errors.where(fee_payment_date_field)).to be_empty
          end
        end

        context "with #{fee_payment_method_field} attribute" do
          it 'does not validate presence' do
            expect(form).not_to validate_presence_of(fee_payment_method_field)
          end
        end
      end

      shared_examples 'any fee' do |fee_name:|
        it 'validates numeric values disallowing negative values' do
          expect(form).to validate_numericality_of("#{fee_name}_fee").
            is_greater_than_or_equal_to(0)
        end
      end

      # Start of validation specs
      context 'with positive fees as float with known date' do
        include_examples 'a positive fee with known date', fee_name: :et_issue, fee: 12
        include_examples 'a positive fee with known date', fee_name: :et_hearing, fee: 12
        include_examples 'a positive fee with known date', fee_name: :et_reconsideration, fee: 12
        include_examples 'a positive fee with known date', fee_name: :eat_issue, fee: 12
        include_examples 'a positive fee with known date', fee_name: :eat_hearing, fee: 12
      end

      context 'with positive fees as string with known date' do
        include_examples 'a positive fee with known date', fee_name: :et_issue, fee: '12'
        include_examples 'a positive fee with known date', fee_name: :et_hearing, fee: '12'
        include_examples 'a positive fee with known date', fee_name: :et_reconsideration, fee: '12'
        include_examples 'a positive fee with known date', fee_name: :eat_issue, fee: '12'
        include_examples 'a positive fee with known date', fee_name: :eat_hearing, fee: '12'
      end

      context 'with positive fees as float with unknown date' do
        include_examples 'a positive fee with unknown date', fee_name: :et_issue, fee: 12
        include_examples 'a positive fee with unknown date', fee_name: :et_hearing, fee: 12
        include_examples 'a positive fee with unknown date', fee_name: :et_reconsideration, fee: 12
        include_examples 'a positive fee with unknown date', fee_name: :eat_issue, fee: 12
        include_examples 'a positive fee with unknown date', fee_name: :eat_hearing, fee: 12
      end

      context 'with positive fees as string with unknown date' do
        include_examples 'a positive fee with unknown date', fee_name: :et_issue, fee: '12'
        include_examples 'a positive fee with unknown date', fee_name: :et_hearing, fee: '12'
        include_examples 'a positive fee with unknown date', fee_name: :et_reconsideration, fee: '12'
        include_examples 'a positive fee with unknown date', fee_name: :eat_issue, fee: '12'
        include_examples 'a positive fee with unknown date', fee_name: :eat_hearing, fee: '12'
      end

      context 'with no fees' do
        include_examples 'a zero or nil fee', fee_name: :et_issue, fee: nil
        include_examples 'a zero or nil fee', fee_name: :et_hearing, fee: nil
        include_examples 'a zero or nil fee', fee_name: :et_reconsideration, fee: nil
        include_examples 'a zero or nil fee', fee_name: :eat_issue, fee: nil
        include_examples 'a zero or nil fee', fee_name: :eat_hearing, fee: nil

        it 'fails validation as there are no fees represented as empty string' do
          [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].each do |m|
            form.send(:"#{m}=", '')
          end

          form.valid?
          expect(form.errors.where(:base)).to include(have_attributes(message: 'You must enter a fee in the relevant field'))
        end

        it 'fails validation as there are no fees represented as nil' do
          [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].each do |m|
            form.send(:"#{m}=", nil)
          end

          form.valid?
          expect(form.errors.where(:base)).to include(have_attributes(message: 'You must enter a fee in the relevant field'))
        end
      end

      context 'with zero fees' do
        include_examples 'a zero or nil fee', fee_name: :et_issue, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :et_hearing, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :et_reconsideration, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :eat_issue, fee: 0.0
        include_examples 'a zero or nil fee', fee_name: :eat_hearing, fee: 0.0

        it 'fails validation as there are no fees' do
          [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].each do |m|
            form.send(:"#{m}=", '0')
          end
          form.valid?
          expect(form.errors.where(:base)).to include(have_attributes(message: 'You must enter a fee in the relevant field'))
        end
      end

      context 'with common validations per fee' do
        include_examples 'any fee', fee_name: :et_issue
        include_examples 'any fee', fee_name: :et_hearing
        include_examples 'any fee', fee_name: :et_reconsideration
        include_examples 'any fee', fee_name: :eat_issue
        include_examples 'any fee', fee_name: :eat_hearing
      end
    end

    context 'with attribute writers' do
      shared_examples 'a fee date writer' do |fee_name:|
        reader_method = :"#{fee_name}_fee_payment_date"
        writer_method = :"#{fee_name}_fee_payment_date="
        it 'converts a partial date from a hash' do
          form.send(writer_method, 2 => '12', 1 => '2016')
          expect(form.send(reader_method)).to eql Date.parse('1 December 2016')
        end

        it 'converts an empty partial date from a hash to nil' do
          value = { "#{reader_method}(2i)" => '',
                    "#{reader_method}(1i)" => '' }
          form.assign_attributes(value)
          expect(form.send(reader_method)).to be_nil
        end

        it 'converts a full date from a hash' do
          form.send(writer_method, 2 => 12, 1 => 2016, 3 => 12)
          expect(form.send(reader_method)).to eql Date.parse('12 December 2016')
        end

        it 'converts a full date from a yyyy-mm-dd string' do
          form.send(writer_method, '2016-12-24')
          expect(form.send(reader_method)).to eql Date.parse('24 December 2016')
        end

        it 'leaves an invalid date from a hash as is' do
          form.send(writer_method, 2 => 13, 1 => 2016)
          expect(form.send(:"#{reader_method}_before_type_cast")).to eql(1 => 2016, 2 => 13), "Expected invalid month to have converted to nil for '#{writer_method}'"
        end

        it 'converts a partial date from an action controller params instance' do
          value = ActionController::Parameters.new("#{reader_method}(2i)" => '12',
                                                   "#{reader_method}(1i)" => '2016').permit!
          form.assign_attributes(value)
          expect(form.send(reader_method)).to eql Date.parse('1 December 2016')
        end

        it 'converts an empty partial date from an action controller to nil' do
          value = ActionController::Parameters.new("#{reader_method}(2i)" => '',
                                                   "#{reader_method}(1i)" => '').permit!
          form.assign_attributes(value)
          expect(form.send(reader_method)).to be_nil
        end

        it 'converts a full date from an action controller params instance' do
          value = ActionController::Parameters.new("#{reader_method}(3i)" => '10',
                                                   "#{reader_method}(2i)" => '12',
                                                   "#{reader_method}(1i)" => '2016').permit!
          form.assign_attributes(value)
          expect(form.send(reader_method)).to eql Date.parse('10 December 2016')
        end

        it 'leaves an invalid date as a hash from an action controller params instance as is' do
          value = ActionController::Parameters.new("#{reader_method}(2i)" => '13',
                                                   "#{reader_method}(1i)" => '2016').permit!
          form.assign_attributes(value)
          expect(form.send(:"#{reader_method}_before_type_cast")).to eql 2 => 13, 1 => 2016
        end

        it 'does not convert nil' do
          form.send(writer_method, nil)
          expect(form.send(reader_method)).to be_nil
        end
      end

      shared_examples 'a fee amount writer' do |fee_name:|
        reader_method = :"#{fee_name}_fee"
        reader_before_cast_method = :"#{fee_name}_fee_before_type_cast"
        writer_method = :"#{fee_name}_fee="
        it 'converts an amount from a string' do
          form.send(writer_method, '10.51')
          expect(form.send(reader_method)).to be 10
        end

        it 'converts an amount from a float' do
          form.send(writer_method, 10.51)
          expect(form.send(reader_method)).to be 10
        end

        it 'leaves an invalid number from a string as is' do
          form.send(writer_method, 'non-numeric')
          expect(form.send(reader_before_cast_method)).to eql 'non-numeric'
        end

        it 'does not convert nil' do
          form.send(writer_method, nil)
          expect(form.send(reader_method)).to be_nil
        end
      end

      context 'with fee date writers' do
        include_examples 'a fee date writer', fee_name: :et_issue
        include_examples 'a fee date writer', fee_name: :et_hearing
        include_examples 'a fee date writer', fee_name: :et_reconsideration
        include_examples 'a fee date writer', fee_name: :eat_issue
        include_examples 'a fee date writer', fee_name: :eat_hearing
      end

      context 'with fee amount writers' do
        include_examples 'a fee amount writer', fee_name: :et_issue
        include_examples 'a fee amount writer', fee_name: :et_hearing
        include_examples 'a fee amount writer', fee_name: :et_reconsideration
        include_examples 'a fee amount writer', fee_name: :eat_issue
        include_examples 'a fee amount writer', fee_name: :eat_hearing
      end
    end
  end
end
