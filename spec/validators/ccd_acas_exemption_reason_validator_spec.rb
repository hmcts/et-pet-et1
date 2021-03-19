require 'rails_helper'
RSpec.describe CcdAcasExemptionReasonValidator do
  let(:valid_values) do
    ['joint_claimant_has_acas_number', 'acas_has_no_jurisdiction', 'employer_contacted_acas', 'interim_relief']
  end
  let(:invalid_values) do
    ['No acas', 'I contacted acas', 'wrong acas']
  end

  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :no_acas_number_reason

      def self.name
        'MyModel'
      end

      validates :no_acas_number_reason, ccd_acas_exemption_reason: true
    end
  end

  it 'is valid for all in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(no_acas_number_reason: value)

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is valid for all downcased values in the valid list' do
    aggregate_failures 'validating all in valid list' do
      valid_values.each do |value|
        model = model_class.new(no_acas_number_reason: value.downcase)

        model.valid?

        expect(model.errors).to be_empty, "expected #{value} to be valid but it wasn't"
      end
    end
  end

  it 'is not valid for nil' do
    model = model_class.new(no_acas_number_reason: nil)

    model.valid?

    expect(model.errors.details[:no_acas_number_reason]).to include a_hash_including(error: :invalid_cdd_acas_exemption_reason)
  end

  it 'is not valid for an empty string' do
    model = model_class.new(no_acas_number_reason: '')

    model.valid?
    expect(model.errors.details[:no_acas_number_reason]).to include a_hash_including(error: :invalid_cdd_acas_exemption_reason)
  end

  it 'does not validate for some strings outside of the allow list' do
    aggregate_failures 'validating all lowercase variations of the allow list' do
      invalid_values.each do |value|
        model = model_class.new(no_acas_number_reason: value.downcase)

        model.valid?

        expect(model.errors.details[:no_acas_number_reason]).to include(a_hash_including(error: :invalid_cdd_acas_exemption_reason)), "expected #{value} to be invalid but it wasn't"
      end
    end
  end
end
