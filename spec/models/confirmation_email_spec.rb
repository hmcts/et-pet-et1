require 'rails_helper'

describe ConfirmationEmail do
  let(:confirmation_email) { described_class.new }

  it 'has 5 slots for email addresses' do
    expect(confirmation_email.additional_email_address.size).to eq(5)
  end
end
