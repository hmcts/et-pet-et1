require 'rails_helper'
RSpec.describe DateRangeValidator do
  let(:valid_values) do
    ["5,1,#{99.years.ago.year}", "2,1,#{11.years.ago.year}", "21,5,#{50.years.ago.year}"]
  end
  let(:model) { ModelClass.new }
  let(:invalid_values) do
    ["1,1,#{9.years.ago.year}", "15,1,#{102.years.ago.year}"]
  end

  class ModelClass < ApplicationRecord
    establish_connection adapter: :nulldb,
                         schema: 'config/nulldb_schema.rb'

    attribute :date_of_birth, :et_date

    validates :date_of_birth, date_range: { range: -> { 100.years.ago..10.years.ago } }
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

        expect(model.errors.details[:date_of_birth]).to include(a_hash_including(error: :date_range))
      end
    end
  end
end
