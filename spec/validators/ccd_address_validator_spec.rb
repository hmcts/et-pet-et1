require 'rails_helper'
RSpec.describe CcdAddressValidator do
  let(:valid_values) do
    ['40 Station Road', '9209 Grange Road', '81 Highfield Road', '8 Broadway', '9691 The Avenue']
  end
  let(:invalid_values) do
    ['40stationroadadresdefrtghyjuikonhgvfesadfgtreaqwdrf', '9209GrangeRoadadresdefrtghyjuikonhgvfesadfgtreaqwdrf', '81HighfieldRoadadresdefrtghyjuikonhgvfesadfgtreaqwdrf']
  end

  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :example_address_street

      def self.name
        'MyModel'
      end

      validates :example_address_street, ccd_address: true
    end
  end

  it 'is valid for all in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(example_address_street: value)

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is valid for all downcased values in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(example_address_street: value.downcase)

        model.valid?

        expect(model.errors).to be_empty, "expected #{value} to be valid but it wasn't"
      end
    end
  end

  it 'is valid for nil' do
    model = model_class.new(example_address_street: nil)

    model.valid?

    expect(model.errors.details[:example_address_street]).to be_empty
  end

  it 'is valid for an empty string' do
    model = model_class.new(example_address_street: '')

    model.valid?
    expect(model.errors.details[:example_address_street]).to be_empty
  end

  it 'does not validate for some strings outside of the allow list' do
    aggregate_failures 'validating all lowercase variations of the allow list' do
      invalid_values.each do |value|
        model = model_class.new(example_address_street: value.downcase)

        model.valid?

        expect(model.errors.details[:example_address_street]).to include(a_hash_including(error: :invalid_ccd_address)), "expected #{value} to be invalid but it wasn't"
      end
    end
  end
end
