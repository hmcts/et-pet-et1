require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

RSpec.shared_examples 'a Form' do |attributes, block|
  let(:proxy)    { double 'proxy', first: nil, second: nil }
  let(:resource) { double 'resource' }
  let(:target)   { double 'target', assign_attributes: nil }
  let(:form)     { described_class.new(attributes) { |f| f.resource = resource } }

  describe 'for valid attributes' do

    it "creates a #{described_class.model_name} on the claim" do
      instance_eval &block
      expect(resource).to receive(:save)

      form.save
      expect(target).to have_received(:assign_attributes).with attributes.slice(*form.attributes.keys)
    end
  end

  if described_class.validators.any?
    describe 'for invalid attributes' do
      let(:attributes) { { } }
      it 'is not saved' do
        expect(resource).to_not receive(:save)
      end
    end
  end
end

RSpec.shared_examples 'it has an address' do |prefix|
  describe 'delegation' do
    [:building, :street, :locality, :county, :post_code, :telephone_number].each do |attr|
      describe "#{prefix}_#{attr}" do
        it "is delegated to ##{prefix} as #{attr}" do
          expect(subject.send(prefix)).to receive(attr)
          subject.send :"#{prefix}_#{attr}"
        end
      end

      describe "#{prefix}_#{attr}=" do
        let(:object) { double }
        it "is delegated to ##{prefix} as #{attr}=" do
          expect(subject.send(prefix)).to receive(:"#{attr}=").with object
          subject.send :"#{prefix}_#{attr}=", object
        end
      end
    end
  end
end
