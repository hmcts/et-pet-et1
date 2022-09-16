require 'rails_helper'
RSpec.describe DateRelativeValidator do
  let(:valid_values) do
    %w[2,1,1999 5,1,1999 12,5,1999]
  end
  let(:invalid_values) do
    %w[31,1,3000 15,1,2025 12,5,2500]
  end

  class ModelClass < ActiveRecord::Base
    establish_connection adapter: :nulldb,
                         schema: 'config/nulldb_schema.rb'


    attribute :date_of_birth, :et_date

    validates :date_of_birth, date_relative: { in_the_past: true}
  end

  let(:model) { ModelClass.new }

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

        expect(model.errors.details[:date_of_birth]).to include(a_hash_including(error: :less_than))
      end
    end
  end
end
