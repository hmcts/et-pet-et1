require 'rails_helper'
RSpec.describe CcdPostCodeValidator do
  let(:valid_values) do
    %w[SL44QG PL253SG OX266AY LL145DN WA101HE BN998AR OL129HE LE29LE GL15AW TN57PL GIR0AA]
  end
  let(:invalid_values) do
    ['QE21AA', 'BI43QQ', 'DE 21 7QQ', 'SL4 4QG']
  end
  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :post_code

      def self.name
        'MyModel'
      end

      validates :post_code, ccd_post_code: true
    end
  end

  it 'is valid for all in the valid list' do
    aggregate_failures 'validating all in allow list' do
      valid_values.each do |value|
        model = model_class.new(post_code: value)

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is valid for all downcased values in the valid list' do
    aggregate_failures 'validating all in allow list' do
      valid_values.each do |value|
        model = model_class.new(post_code: value.downcase)

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is not valid for nil' do
    model = model_class.new(post_code: nil)

    model.valid?

    expect(model.errors.details[:post_code]).to include a_hash_including(error: :invalid_ccd_post_code)
  end

  it 'is not valid for an empty string' do
    model = model_class.new(post_code: '')

    model.valid?
    expect(model.errors.details[:post_code]).to include a_hash_including(error: :invalid_ccd_post_code)
  end

  it 'does not validate for some strings outside of the allow list' do
    aggregate_failures 'validating all lowercase variations of the allow list' do
      invalid_values.each do |value|
        model = model_class.new(post_code: value.downcase)

        model.valid?

        expect(model.errors.details[:post_code]).to include a_hash_including(error: :invalid_ccd_post_code)
      end
    end
  end
end
