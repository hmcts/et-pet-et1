require 'rails_helper'

feature 'Login after submission', type: :feature do
  include FormMethods

  let(:claim) do
    Claim.create(password: 'lololol') { |c| c.state = 'submitted' }
  end

  scenario 'User attepts login after claim has been submitted' do
    visit new_claim_session_path
    fill_in_return_form claim.reference, 'lololol'

    expect(page.current_path).to eq user_session_path(locale: :en)
    expect(page).to have_text "This claim has been submitted and can no longer be edited online"
  end
end
