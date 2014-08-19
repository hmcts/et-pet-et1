require 'rails_helper'

feature 'Return to your saved form' do
  include FormMethods

  scenario 'returning to existing application' do
    start_claim
    fill_in_password 'green'
    fill_in_return_form Claim.last.reference, 'green'

    expect(page).to have_text('Your details')
  end
end
