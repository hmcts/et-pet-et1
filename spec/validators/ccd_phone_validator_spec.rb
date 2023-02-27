require 'rails_helper'
RSpec.describe CcdPhoneValidator do

  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :number

      def self.name
        'MyModel'
      end

      validates :number, ccd_phone: true
    end
  end

  it 'will not validate a string with non-integer, "+", "-" or " " characters' do
    model = model_class.new(number: "not even a number")

    model.valid?

    expect(model.errors.details[:number]).to include a_hash_including(error: :invalid_ccd_phone)
  end

  it 'will validate a string that starts with an international call code with spaces' do
    model = model_class.new(number: "+44 1203 123 456")

    model.valid?

    expect(model.errors).not_to include :number
  end

  it 'will validate a string that starts with an international call code without spaces' do
    model = model_class.new(number: "+441203123456")

    model.valid?

    expect(model.errors).not_to include :number
  end

  it 'will validate a string of integers with spaces' do
    model = model_class.new(number: "02031 234 567")

    model.valid?

    expect(model.errors).not_to include :number
  end

  it 'will validate a string of integers with spaces and brackets around std code' do
    model = model_class.new(number: "(02031) 234 567")

    model.valid?

    expect(model.errors).not_to include :number
  end

  it 'will validate a string of integers without spaces' do
    model = model_class.new(number: "02031234567")

    model.valid?

    expect(model.errors).not_to include :number
  end

  it 'will not validate a string with less than 6 integers after the STD code' do
    model = model_class.new(number: "+44133280923")

    model.valid?

    expect(model.errors.details[:number]).to include a_hash_including(error: :invalid_ccd_phone)
  end

  it 'will not validate a string with a "+" anywhere other than the first character' do
    model = model_class.new(number: "+44+203 123 4567")

    model.valid?

    expect(model.errors.details[:number]).to include a_hash_including(error: :invalid_ccd_phone)
  end
end
