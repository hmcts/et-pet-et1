require 'rails_helper'
RSpec.describe CcdEmailValidator do
  let(:valid_values) do
    ['test@example.com', 'fred@bloggs.com', 'test@example.sub.com', 'test@example.sub.sub.com', 'test@example.abcom']
  end
  let(:invalid_values) do
    ['a space@example.com', 'test*@email.com', 'test@example.toolongdomain']
  end

  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :email

      def self.name
        'MyModel'
      end

      validates :email, ccd_email: true
    end
  end

  it 'is valid for all in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(email: value)

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is valid for all upcased values in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(email: value.upcase)

        model.valid?

        expect(model.errors).to be_empty, "expected #{value} to be valid but it wasn't"
      end
    end
  end

  it 'is valid for nil' do
    model = model_class.new(email: nil)

    model.valid?

    expect(model.errors).to be_empty
  end

  it 'is not valid for an empty string' do
    model = model_class.new(email: '')

    model.valid?
    expect(model.errors.details[:email]).to include a_hash_including(error: :invalid_ccd_email)
  end

  it 'does not validate for strings from the invalid values' do
    aggregate_failures 'validating all of the invalid values' do
      invalid_values.each do |value|
        model = model_class.new(email: value)

        model.valid?

        expect(model.errors.details[:email]).to include(a_hash_including(error: :invalid_ccd_email)), "expected #{value} to be invalid but it wasn't"
      end
    end
  end
end
