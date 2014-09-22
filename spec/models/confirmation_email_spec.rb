require 'rails_helper'

describe ConfirmationEmail do
  it 'has 5 slots for email addresses' do
    expect(subject.additional_email_address.size).to eq(5)
  end
end
