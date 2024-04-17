require 'rails_helper'

class ModelClass < ApplicationRecord
  establish_connection adapter: :nulldb,
                       schema: 'config/nulldb_schema.rb'

  attribute :date_of_birth, :et_date

  validates :date_of_birth, date: true
end

RSpec.describe DateValidator do
  let(:valid_values) do
    ['2,1,1999', '5,1,1999', '12,5,1999']
  end
  let(:model) { ModelClass.new }
  let(:invalid_values) do
    ['31,2,1999', '1,15,1999', '12,5,199']
  end

  it 'is valid for all in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        values = value.split(',')
        model.attributes = {
          'date_of_birth(1i)' => values[2],
          'date_of_birth(2i)' => values[1],
          'date_of_birth(3i)' => values[0]
        }

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is invalid for all in the invalid list' do
    aggregate_failures 'validating all in invalid list' do
      invalid_values.each do |value|
        values = value.split(',')
        model.attributes = {
          'date_of_birth(1i)' => values[2],
          'date_of_birth(2i)' => values[1],
          'date_of_birth(3i)' => values[0]
        }

        model.valid?

        expect(model.errors.details[:date_of_birth]).to include(a_hash_including(error: :invalid))
      end
    end
  end
end
