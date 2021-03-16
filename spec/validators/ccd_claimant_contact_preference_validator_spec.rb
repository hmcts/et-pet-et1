require 'rails_helper'
RSpec.describe CcdClaimantContactPreferenceValidator do
  let(:valid_values) do
    ['post', 'email']
  end
  let(:invalid_values) do
    ['phone', 'message']
  end

  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :contact_preference

      def self.name
        'MyModel'
      end

      validates :contact_preference, ccd_claimant_contact_preference: true
    end
  end

  it 'is valid for all in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(contact_preference: value)

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is valid for all downcased values in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(contact_preference: value.downcase)

        model.valid?

        expect(model.errors).to be_empty, "expected #{value} to be valid but it wasn't"
      end
    end
  end

  it 'is not valid for nil' do
    model = model_class.new(contact_preference: nil)

    model.valid?

    expect(model.errors.details[:contact_preference]).to include a_hash_including(error: :invalid_ccd_claimant_contact_preference)
  end

  it 'is not valid for an empty string' do
    model = model_class.new(contact_preference: '')

    model.valid?
    expect(model.errors.details[:contact_preference]).to include a_hash_including(error: :invalid_ccd_claimant_contact_preference)
  end

  it 'does not validate for some strings outside of the allow list' do
    aggregate_failures 'validating all lowercase variations of the allow list' do
      invalid_values.each do |value|
        model = model_class.new(contact_preference: value.downcase)

        model.valid?

        expect(model.errors.details[:contact_preference]).to include(a_hash_including(error: :invalid_ccd_claimant_contact_preference)), "expected #{value} to be invalid but it wasn't"
      end
    end
  end
end
