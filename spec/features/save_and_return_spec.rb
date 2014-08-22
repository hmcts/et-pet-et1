require 'rails_helper'

feature 'Save and Return' do
  include FormMethods

  scenario 'ending the session' do
    start_claim
    fill_in_password
    fill_in_personal_details(submit_form: false)

    click_button 'Save now and complete later'
    expect(page).to have_text('Saved')
    expect(page).to have_text(Claim.last.reference)
    click_button 'Sign out now'

    expect(page).to have_text('Take your employer to a tribunal')
  end

  scenario 'returning to existing application' do
    start_claim
    fill_in_password 'green'
    fill_in_personal_details(submit_form: false)
    end_session
    fill_in_return_form Claim.last.reference, 'green'

    expect(page).to have_text('Your details')
    expect(page).to have_field('Last name', with: 'Wrigglesworth')
  end
end
