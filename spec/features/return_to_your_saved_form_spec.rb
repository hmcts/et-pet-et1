require 'rails_helper'

feature 'Return to your saved form' do
  include FormMethods

  scenario 'returning to existing application' do
    start_claim
    fill_in_password 'green'
    form_number = Claim.last.reference
    fill_in_return_form form_number, 'green'
  end
end
