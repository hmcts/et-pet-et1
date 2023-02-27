require 'rails_helper'
RSpec.describe CcdPersonalTitleValidator do
  let(:allow_list) { ['Mr', 'Mrs', 'Miss', 'Ms', 'Mx', 'Dr', 'Prof', 'Sir', 'Lord', 'Lady', 'Dame', 'Capt', 'Rev', 'Other', 'N/K'] }
  let(:example_deny_list) { ['Doctor', 'Professor', 'Captain', 'Reverend', 'badtitle'] }
  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :title

      def self.name
        'MyModel'
      end

      validates :title, ccd_personal_title: true
    end
  end

  it 'is valid for all in the allow list' do
    aggregate_failures 'validating all in allow list' do
      allow_list.each do |value|
        model = model_class.new(title: value)

        model.valid?

        expect(model.errors).to be_empty
      end
    end
  end

  it 'is valid for nil' do
    model = model_class.new(title: nil)

    model.valid?

    expect(model.errors).to be_empty
  end

  it 'is not valid for an empty string' do
    model = model_class.new(title: '')

    model.valid?
    expect(model.errors.details[:title]).to include a_hash_including(error: :invalid_ccd_personal_title)
  end

  it 'does not validate for all lowercase variations of the allow list' do
    aggregate_failures 'validating all lowercase variations of the allow list' do
      allow_list.each do |value|
        model = model_class.new(title: value.downcase)

        model.valid?

        expect(model.errors.details[:title]).to include a_hash_including(error: :invalid_ccd_personal_title)
      end
    end
  end

  it 'does not validate for some strings outside of the allow list' do
    aggregate_failures 'validating all lowercase variations of the allow list' do
      allow_list.each do |value|
        model = model_class.new(title: value.downcase)

        model.valid?

        expect(model.errors.details[:title]).to include a_hash_including(error: :invalid_ccd_personal_title)
      end
    end
  end
end
