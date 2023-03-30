require 'rails_helper'
RSpec.describe SpecialCharacterValidator do

  let(:model) { ModelClass.new }
  let(:valid_attributes) do
    {
      first_name: 'name',
      address_building: '12',
      address_postcode: 'DV1 GJ1',
      address_with_comma: 'home, address',
    }
  end
  let(:valid_attributes_with_comma) do
    {
      first_name: 'name',
      address_building: '12,,,,,',
      address_postcode: 'DV1 GJ1',
      address_with_comma: 'home, address',
    }
  end
  let(:invalid_attributes) do
    {
      first_name: 'qwe<',
      address_building: '&*(',
      address_postcode: 'DV1 GJ1,',
      address_with_comma: 'home, address42434',
    }
  end
  class ModelClass < ApplicationRecord
    establish_connection adapter: :nulldb,
                         schema: 'config/nulldb_schema.rb'

    attribute :first_name,                :string
    attribute :address_building,         :string
    attribute :address_postcode,         :string
    attribute :address_with_comma,         :string

    validates :first_name, special_character: true
    validates :address_building, special_character: { comma: true, number: true }
    validates :address_postcode, special_character: { number: true }
    validates :address_with_comma, special_character: { comma: true }

  end

  it 'is valid for an input with no special characters' do
    model.attributes = valid_attributes
    model.valid?
    expect(model.errors).to be_empty
  end

  it 'is not valid for an input with special characters' do
    model.attributes = invalid_attributes
    model.valid?

    expect(model.errors.where(:first_name, :contains_special_characters)).to be_present
    expect(model.errors.where(:address_building, :contains_special_characters)).to be_present
    expect(model.errors.where(:address_postcode, :contains_special_characters)).to be_present
    expect(model.errors.where(:address_with_comma, :contains_special_characters)).to be_present

  end

  it 'is valid for address_building when there is a comma in the input' do
    model.attributes = valid_attributes_with_comma
    model.valid?
    expect(model.errors).to be_empty
  end

end
