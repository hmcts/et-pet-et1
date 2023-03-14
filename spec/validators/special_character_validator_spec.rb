require 'rails_helper'
RSpec.describe SpecialCharacterValidator do

  let(:model) { ModelClass.new }
  let(:valid_attributes) do
    {
      first_name: 'name',
      last_name: 'last',
      address_building: '12',
      address_street: 'street name',
      address_locality: 'local',
      address_county: 'county',
    }
  end
  let(:valid_attributes_with_comma) do
    {
      first_name: 'name',
      last_name: 'last',
      address_building: '12,,,,,',
      address_street: 'street name',
      address_locality: 'local',
      address_county: 'county',
    }
  end
  let(:invalid_attributes) do
    {
      first_name: 'qwe<',
      last_name: '&*()',
      address_building: '&*(',
      address_street: ')(*',
      address_locality: '*()',
      address_county: '*()',
    }
  end
  class ModelClass < ActiveRecord::Base
    establish_connection adapter: :nulldb,
                         schema: 'config/nulldb_schema.rb'

    attribute :first_name,                :string
    attribute :last_name,                :string
    attribute :address_building,         :string
    attribute :address_street,           :string
    attribute :address_locality,         :string
    attribute :address_county,           :string

    validates :first_name, :last_name, special_character: true
    validates :address_street, :address_locality, :address_county, special_character: true
    validates :address_building, special_character: { comma: true }

  end

  it 'is valid for an input with no special characters' do
    model.attributes = valid_attributes
    model.valid?
    expect(model.errors).to be_empty
  end

  it 'is not valid for an input with special characters' do
    model.attributes = invalid_attributes
    model.valid?
    model.errors.details.each do |error|
      expect(error).to include(a_hash_including(error: :contains_special_characters))
    end
  end

  it 'is valid for address_building when there is a comma in the input'do
    model.attributes = valid_attributes_with_comma
    model.valid?
    expect(model.errors).to be_empty
  end

end
