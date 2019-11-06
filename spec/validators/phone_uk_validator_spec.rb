require 'rails_helper'
RSpec.describe PhoneNumberUkValidator do

  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :number

      def self.name
        'MyModel'
      end

      validates :number, phone_number_uk: true
    end
  end

  it 'will not validate a string with non-integer, "+", "-" or " " characters' do
    model = model_class.new(number: "not even a number")

    model.valid?

    expect(model.errors.details[:number]).to include a_hash_including(error: :invalid_phone_number)
  end

  it 'will validate a string of integers with spaces' do
    model = model_class.new(number: "0203 123 4567")

    model.valid?

    expect(model.errors).not_to include :number
  end

  it 'will not validate a string with less than 7 integers' do
    model = model_class.new(number: "+44------4567")

    model.valid?

    expect(model.errors.details[:number]).to include a_hash_including(error: :invalid_phone_number)
  end

  it 'will validate a string that starts with an international call code' do
    model = model_class.new(number: "+44 203 123 4567")

    model.valid?

    expect(model.errors).not_to include :number
  end

  it 'will not validate a string with a "+" anywhere other than the first character' do
    model = model_class.new(number: "+44+203 123 4567")

    model.valid?

    expect(model.errors.details[:number]).to include a_hash_including(error: :invalid_phone_number)
  end

  it 'will validate a string with 7 integers and dashes' do
    model = model_class.new(number: "0203-123-4567")

    model.valid?

    expect(model.errors).not_to include :number
  end

end
