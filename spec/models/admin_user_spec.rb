# frozen_string_literal: true

require 'rspec'

RSpec.describe AdminUser do
  describe '#devise_mailer' do
    it 'overrides the mailer' do
      expect(described_class.new.devise_mailer).to eq(Devise::Mailer)
    end
  end
end
