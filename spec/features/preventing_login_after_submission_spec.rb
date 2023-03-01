require 'rails_helper'

describe 'Login after submission', type: :feature do
  include FormMethods

  let(:claim) do
    Claim.create(user: User.new(password: 'lololol')) { |c| c.state = 'submitted' }
  end

  it 'User attepts login after claim has been submitted' do
    fill_in_return_form claim.reference, 'lololol'

    expect(page).to have_current_path user_session_path(locale: :en), ignore_query: true
    expect(page).to have_text "This claim has been submitted and can no longer be edited online"
  end
end
