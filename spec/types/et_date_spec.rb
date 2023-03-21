require 'rails_helper'

RSpec.describe EtDateType do
  class ExampleForm < ApplicationRecord
    establish_connection adapter: :nulldb,
                         schema: 'config/nulldb_schema.rb'
    attribute :date, :et_date
  end

  let(:form) { ExampleForm.new }

  describe 'multi parameter assignment' do
    it 'converts valid value' do
      form.attributes = {
        'date(1i)' => '2000',
        'date(2i)' => '2',
        'date(3i)' => '28'
      }
      expect(form.date).to eql(Date.parse('2000-02-28'))
    end

    it 'does not convert an invalid value - 30th february' do
      form.attributes = {
        'date(1i)' => '2000',
        'date(2i)' => '2',
        'date(3i)' => '30'
      }
      expect(form.date).to be_nil
    end

    it 'retains the invalid value - 30th february' do
      form.attributes = {
        'date(1i)' => '2000',
        'date(2i)' => '2',
        'date(3i)' => '30'
      }
      expect(form.read_attribute_before_type_cast(:date)).to eql 1 => 2000, 2 => 2, 3 => 30
    end

    it 'does not convert an invalid value - non numeric month' do
      form.attributes = {
        'date(1i)' => '2000',
        'date(2i)' => 'feb',
        'date(3i)' => '30'
      }
      expect(form.date).to be_nil
    end

    it 'retains the invalid value - 30th february - has zero value' do
      form.attributes = {
        'date(1i)' => '2000',
        'date(2i)' => 'feb',
        'date(3i)' => '30'
      }
      expect(form.read_attribute_before_type_cast(:date)).to eql 1 => 2000, 2 => 0, 3 => 30
    end
  end

  context 'configured with allow_2_digit_year' do
    class FormWith2Digit < ApplicationRecord
      establish_connection adapter: :nulldb,
                           schema: 'config/nulldb_schema.rb'
      attribute :date, :et_date, allow_2_digit_year: true
    end
    let(:form) { FormWith2Digit.new }

    describe 'multi parameter assignment' do
      it 'converts valid value' do
        form.attributes = {
          'date(1i)' => '70',
          'date(2i)' => '2',
          'date(3i)' => '28'
        }
        expect(form.date).to eql(Date.parse('1970-02-28'))
      end

      it 'does not convert an invalid value' do
        form.attributes = {
          'date(1i)' => '70',
          'date(2i)' => '2',
          'date(3i)' => '30'
        }
        expect(form.date).to be_nil
      end

      it 'retains the invalid value' do
        form.attributes = {
          'date(1i)' => '70',
          'date(2i)' => '2',
          'date(3i)' => '30'
        }
        expect(form.read_attribute_before_type_cast(:date)).to eql 1 => 70, 2 => 2, 3 => 30
      end
    end

  end

  context 'configured with omit_day' do
    class FormWithOmitDay < ApplicationRecord
      establish_connection adapter: :nulldb,
                           schema: 'config/nulldb_schema.rb'
      attribute :date, :et_date, omit_day: true
    end
    let(:form) { FormWithOmitDay.new }

    describe 'multi parameter assignment' do
      it 'converts valid value' do
        form.attributes = {
          'date(1i)' => '2000',
          'date(2i)' => '2'
        }
        expect(form.date).to eql(Date.parse('2000-02-01'))
      end

      it 'does not convert an invalid value' do
        form.attributes = {
          'date(1i)' => '2000',
          'date(2i)' => '13'
        }
        expect(form.date).to be_nil
      end

      it 'retains the invalid value' do
        form.attributes = {
          'date(1i)' => '2000',
          'date(2i)' => '13'
        }
        expect(form.read_attribute_before_type_cast(:date)).to eql 1 => 2000, 2 => 13
      end
    end

  end
end
