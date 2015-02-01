require 'rails_helper'

RSpec.feature 'Feedback form' do
  before { stub_request(:post, /.+/) }

  scenario 'filling in the feedback form' do
    visit feedback_path

    expect(page).not_to have_button('Save and complete later')

    fill_in 'What did work well for you?',      with: 'lél'
    fill_in 'How can we improve this service?', with: 'get #rekt'
    fill_in 'Email address',                    with: 'lewl@example.com'

    click_button 'Send feedback'

    expect(page).to have_text "Thank you for your feedback"
  end
end
