require 'rails_helper'

class ModelClass < ApplicationRecord
  establish_connection adapter: :nulldb,
                       schema: 'config/nulldb_schema.rb'

  attribute :dx_number, :string

  validates :dx_number, dx_string: true

end

RSpec.describe DxStringValidator do

  let(:model) { ModelClass.new }
  let(:valid_attributes) do
    {
      dx_number: 'Na1 12-3',
    }
  end
  let(:invalid_attributes) do
    {
      dx_number: '£$%^&*<',
    }
  end

  it 'is valid for an input with no special characters' do
    model.attributes = valid_attributes
    model.valid?
    expect(model.errors).to be_empty
  end

  it 'is not valid for an input with special characters' do
    model.attributes = invalid_attributes
    model.valid?

    expect(model.errors.where(:dx_number, :invalid_dx)).to be_present

  end
end
